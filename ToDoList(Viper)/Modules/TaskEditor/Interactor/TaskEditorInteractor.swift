//
//  TaskEditorInteractor.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 27.01.25.
//

import Foundation

class TaskEditorInteractor: TaskEditorInteractorProtocol {
    
    weak var presenter: TaskEditorPresenterProtocol?

    func saveTaskInCoreData(title: String, description: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let task = TaskEntity(title: title, description: description, dueDate: Date(), isCompleted: false)
        CoreDataManager.shared.saveTaskToCoreData(task) { result in
            completion(result)
        }
    }

    func updateTaskInCoreData(task: TaskEntity, withTitle title: String, description: String, completion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataManager.shared.update(task: task, withTitle: title, description: description) { result in completion(result)
        }
    }
}
