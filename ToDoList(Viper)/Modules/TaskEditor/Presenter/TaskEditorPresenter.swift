//
//  TaskEditorPresenter.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 27.01.25.
//

import Foundation

final class TaskEditorPresenter: TaskEditorPresenterProtocol {

    weak var view: TaskEditorViewProtocol?
    var interactor: TaskEditorInteractorProtocol?
    var router: TaskEditorRouterProtocol?
    var onSave: ((TaskEntity) -> Void)?

    private var originalTask: TaskEntity?

    init(task: TaskEntity?) {
        self.originalTask = task
    }

    func saveTask(title: String, description: String) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            router?.dismiss()
            return
        }
        interactor?.saveTaskInCoreData(title: title, description: description) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let task):
                    self?.onSave?(task)
                    self?.router?.dismiss()
                case .failure(let error):
                    self?.view?.showError(title: "Ошибка сохранения", message: error.localizedDescription)
                }
            }
        }
    }

    func updateTask(withId id: Int, newTitle: String, newDescription: String) {
        guard !newTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        guard newTitle != originalTask?.title || newDescription != originalTask?.description else {
            router?.dismiss()
            return
        }

        interactor?.updateTask(withId: id, newTitle: newTitle, newDescription: newDescription) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let updatedTask = TaskEntity(
                        id: id,
                        title: newTitle,
                        description: newDescription,
                        dueDate: self?.originalTask?.dueDate ?? Date(),
                        isCompleted: self?.originalTask?.isCompleted ?? false
                    )
                    self?.onSave?(updatedTask)
                    self?.router?.dismiss()
                case .failure(let error):
                    self?.view?.showError(title: "Ошибка обновления", message: error.localizedDescription)
                }
            }
        }
    }
}
