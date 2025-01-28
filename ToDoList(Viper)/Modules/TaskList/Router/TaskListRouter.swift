//
//  TaskListRouter.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 23.01.25.
//

import Foundation
import UIKit
import CoreData

class TaskListRouter: TaskListRouterProtocol {

    weak var viewController: TaskListViewController?

    static func createModule() -> TaskListViewController {
        let viewController = TaskListViewController()
        let presenter: TaskListPresenterProtocol = TaskListPresenter()
        let interactor: TaskListInteractorProtocol = TaskListInteractor()
        let router: TaskListRouterProtocol = TaskListRouter()

        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = viewController

        return viewController
    }

    func navigateToAddTask(completion: @escaping (Result<Void, Error>) -> Void) {
        let taskEditorVC = TaskEditorRouter.createModule()
        taskEditorVC.onTaskListUpdate = { result in
            completion(result)
        }
        viewController?.navigationController?.pushViewController(taskEditorVC, animated: true)
    }

    func navigateToTaskDetails(with task: TaskEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        let taskEditorVC = TaskEditorRouter.createModule(with: task)
        taskEditorVC.onTaskListUpdate = { result in
            completion(result)
        }
        viewController?.navigationController?.pushViewController(taskEditorVC, animated: true)
    }
}
