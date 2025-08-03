//
//  TaskListBuilder.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 31.07.25.
//

import Foundation
import UIKit
import CoreData

final class TaskListBuilder {
    
    static func build(coreDataContainer: NSPersistentContainer) -> UIViewController {
        let viewController = TaskListViewController()
        let presenter = TaskListPresenter()
        let router = TaskListRouter(coreDataContainer: coreDataContainer)

        let coreDataManager = CoreDataManager(persistentContainer: coreDataContainer)
        let networkService = JSONManager()
        
        let interactor = TaskListInteractor(
            networkService: networkService,
            coreDataManager: coreDataManager
        )
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
}
