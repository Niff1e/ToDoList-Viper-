//
//  TaskListRouter.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 23.01.25.
//

import Foundation
import UIKit
import CoreData

final class TaskListRouter: TaskListRouterProtocol {

    weak var viewController: TaskListViewController?
    private let coreDataContainer: NSPersistentContainer

    init(coreDataContainer: NSPersistentContainer) {
        self.coreDataContainer = coreDataContainer
    }

    func navigateToAddTask(completion: @escaping (TaskEntity) -> Void) {
        guard let view = viewController else { return }

        let taskEditorVC = TaskEditorBuilder.build(
            coreDataContainer: self.coreDataContainer,
            onSave: { savedTask in
                completion(savedTask)
            }
        )

        view.navigationController?.pushViewController(taskEditorVC, animated: true)
    }

    func navigateToTaskDetails(with task: TaskEntity, completion: @escaping (TaskEntity) -> Void) {
        guard let view = viewController else { return }

        let taskEditorVC = TaskEditorBuilder.build(
            coreDataContainer: self.coreDataContainer,
            task: task,
            onSave: { updatedTask in
                completion(updatedTask)
            }
        )

        view.navigationController?.pushViewController(taskEditorVC, animated: true)
    }
}
