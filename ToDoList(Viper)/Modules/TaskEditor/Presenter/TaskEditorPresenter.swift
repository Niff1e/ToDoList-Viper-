//
//  TaskEditorPresenter.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 27.01.25.
//

import Foundation

class TaskEditorPresenter: TaskEditorPresenterProtocol {

    weak var view: TaskEditorViewProtocol?
    var interactor: TaskEditorInteractorProtocol?
    var router: TaskEditorRouterProtocol?

    func saveTask(title: String, description: String) {
        interactor?.saveTaskInCoreData(title: title, description: description) { [weak self] result in
            self?.view?.onTaskListUpdate?(result)
        }
    }

    func update(task: TaskEntity, withTitle title: String, description: String) {
        interactor?.updateTaskInCoreData(task: task, withTitle: title, description: description) { [weak self] result in
            self?.view?.onTaskListUpdate?(result)
        }
    }
}
