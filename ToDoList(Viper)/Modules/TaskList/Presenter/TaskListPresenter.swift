//
//  TaskListPresenter.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 23.01.25.
//

import Foundation

final class TaskListPresenter: TaskListPresenterProtocol {
    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?

    private var allTasks: [TaskEntity] = []
    private var visibleTasks: [TaskEntity] = []

    func viewDidLoad() {
        interactor?.fetchTasks()
    }

    func didFetchTasks(_ tasks: [TaskEntity]) {
        self.allTasks = tasks
        self.visibleTasks = tasks
        view?.updateTaskList(self.visibleTasks)
    }

    func didFail(with error: Error) {
        view?.showError(title: "Ошибка", message: error.localizedDescription)
    }

    func toggleTaskCompletion(forId id: Int) {
        interactor?.updateTaskStatus(forId: id)
    }

    func didSucceedToUpdateStatus(forId id: Int) {
        if let index = allTasks.firstIndex(where: { $0.id == id }) {
            allTasks[index].isCompleted.toggle()
        }
        if let index = visibleTasks.firstIndex(where: { $0.id == id }) {
            visibleTasks[index].isCompleted.toggle()
        }
        view?.updateTaskList(visibleTasks)
    }

    func addTask() {
        router?.navigateToAddTask { [weak self] newTask in
            guard let self = self else { return }
            self.allTasks.insert(newTask, at: 0)
            self.visibleTasks = self.allTasks
            self.view?.updateTaskList(self.visibleTasks)
        }
    }

    func editTask(_ task: TaskEntity) {
        router?.navigateToTaskDetails(with: task) { [weak self] updatedTask in
            guard let self = self else { return }

            if let index = self.allTasks.firstIndex(where: { $0.id == updatedTask.id }) {
                self.allTasks[index] = updatedTask
            }
            if let index = self.visibleTasks.firstIndex(where: { $0.id == updatedTask.id }) {
                self.visibleTasks[index] = updatedTask
            }

            self.view?.updateTaskList(self.visibleTasks)
        }
    }

    func deleteTask(withId id: Int) {
        interactor?.deleteTask(withId: id)
    }

    func didSucceedToDelete(withId id: Int) {
        allTasks.removeAll { $0.id == id }
        visibleTasks.removeAll { $0.id == id }
        view?.updateTaskList(visibleTasks)
    }

    func searchTasks(with query: String) {
        if query.isEmpty {
            visibleTasks = allTasks
        } else {
            visibleTasks = allTasks.filter { $0.title.range(of: query, options: .caseInsensitive) != nil }
        }
        view?.updateTaskList(visibleTasks)
    }

    func cancelSearch() {
        visibleTasks = allTasks
        view?.updateTaskList(visibleTasks)
    }
}
