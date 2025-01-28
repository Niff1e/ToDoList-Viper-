//
//  TaskListPresenter.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 23.01.25.
//

import Foundation

class TaskListPresenter: TaskListPresenterProtocol {
    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?

    func viewDidLoad() {
        interactor?.fetchTasks()
    }

    func didFetchTasks(_ tasks: [TaskEntity]) {
        view?.updateTaskList(tasks)
    }

    func didFailToFetchTasks(error: any Error) {
        view?.showError(error.localizedDescription)
    }

    func toggleTaskCompletion(task: TaskEntity) {
        interactor?.updateTaskStatus(task: task)
    }

    func addTask() {
        router?.navigateToAddTask { [weak self] result in
            switch result {
            case .success():
                self?.interactor?.fetchTasks()
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }

    func editTask(_ task: TaskEntity) {
        router?.navigateToTaskDetails(with: task) { [weak self] result in
            switch result {
            case .success():
                self?.interactor?.fetchTasks()
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }

    func deleteTask(_ task: TaskEntity) {
        interactor?.deleteTask(task)
    }

    func didFailToUpdateTask(error: any Error) {
        view?.showError(error.localizedDescription)
    }

    func didFailToDeleteTask(error: any Error) {
        view?.showError(error.localizedDescription)
    }
}
