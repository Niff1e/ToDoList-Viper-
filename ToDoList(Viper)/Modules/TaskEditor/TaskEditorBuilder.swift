//
//  TaskEditorBuilder.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 31.07.25.
//

import Foundation
import UIKit
import CoreData

final class TaskEditorBuilder {
    static func build(coreDataContainer: NSPersistentContainer, task: TaskEntity? = nil, onSave: @escaping (TaskEntity) -> Void) -> UIViewController {
        let view = TaskEditorViewController(task: task)
        let presenter = TaskEditorPresenter(task: task)
        let router = TaskEditorRouter()

        let coreDataManager = CoreDataManager(persistentContainer: coreDataContainer)
        let interactor = TaskEditorInteractor(coreDataManager: coreDataManager)

        view.presenter = presenter
        router.viewController = view
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        presenter.onSave = onSave

        return view
    }
}
