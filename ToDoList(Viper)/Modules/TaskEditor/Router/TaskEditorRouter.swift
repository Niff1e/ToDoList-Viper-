//
//  TaskEditorRouter.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 27.01.25.
//

import Foundation
import UIKit

class TaskEditorRouter: TaskEditorRouterProtocol {

    static func createModule(with task: TaskEntity? = nil) -> TaskEditorViewController {
        let view = TaskEditorViewController(task: task)
        let presenter: TaskEditorPresenterProtocol = TaskEditorPresenter()
        let interactor: TaskEditorInteractorProtocol = TaskEditorInteractor()
        let router: TaskEditorRouterProtocol = TaskEditorRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
}
