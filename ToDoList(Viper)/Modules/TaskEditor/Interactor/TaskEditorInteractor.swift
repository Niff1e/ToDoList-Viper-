//
//  TaskEditorInteractor.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 27.01.25.
//

import Foundation

final class TaskEditorInteractor: TaskEditorInteractorProtocol {
    
    weak var presenter: TaskEditorPresenterProtocol?
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    func saveTaskInCoreData(title: String, description: String, completion: @escaping (Result<TaskEntity, Error>) -> Void) {
        let newId = Int(Date().timeIntervalSince1970)
        let task = TaskEntity(id: newId, title: title, description: description, dueDate: Date(), isCompleted: false)
        coreDataManager.saveTaskToCoreData(task) { result in
            switch result {
            case .success:
                // В случае успеха, возвращаем созданную задачу!
                completion(.success(task))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateTask(withId id: Int, newTitle: String, newDescription: String, completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataManager.updateTask(withId: id, withTitle: newTitle, description: newDescription, completion: completion)
    }
}
