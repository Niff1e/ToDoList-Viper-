//
//  CoreDataManager.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 23.01.25.
//

import Foundation
import CoreData

final class CoreDataManager {

    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    private func saveContext(on context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            throw CoreDataError.saveFailed(error)
        }
    }

    func saveTasksToCoreData(_ tasks: [TaskEntity]) {
        persistentContainer.performBackgroundTask { context in
            tasks.forEach { taskData in
                let taskObject = TaskCoreDataEntity(context: context)
                taskObject.id = Int64(taskData.id)
                taskObject.name = taskData.title
                taskObject.descriptions = taskData.description
                taskObject.completed = taskData.isCompleted
                taskObject.date = taskData.dueDate
            }
            do {
                try self.saveContext(on: context)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func saveTaskToCoreData(_ task: TaskEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        persistentContainer.performBackgroundTask { context in
            let taskObject = TaskCoreDataEntity(context: context)
            taskObject.id = Int64(task.id)
            taskObject.name = task.title
            taskObject.descriptions = task.description
            taskObject.completed = task.isCompleted
            taskObject.date = task.dueDate

            do {
                try context.save()
                DispatchQueue.main.async { completion(.success(())) }
            } catch {
                DispatchQueue.main.async { completion(.failure(CoreDataError.saveFailed(error))) }
            }
        }
    }

    func toggleTaskStatus(withId id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<TaskCoreDataEntity> = TaskCoreDataEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)

            do {
                if let taskToUpdate = try context.fetch(fetchRequest).first {
                    taskToUpdate.completed.toggle()

                    try context.save()
                    DispatchQueue.main.async { completion(.success(())) }
                } else {
                    DispatchQueue.main.async { completion(.failure(CoreDataError.taskNotFound(id: id))) }
                }
            } catch {
                DispatchQueue.main.async { completion(.failure(CoreDataError.saveFailed(error))) }
            }
        }
    }

    func fetchTasksFromCoreData() -> [TaskCoreDataEntity] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskCoreDataEntity> = TaskCoreDataEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print(CoreDataError.fetchFailed(error).localizedDescription)
            return []
        }
    }

    func deleteTask(withId id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<TaskCoreDataEntity> = TaskCoreDataEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)

            do {
                if let taskToDelete = try context.fetch(fetchRequest).first {
                    context.delete(taskToDelete)
                    try context.save()
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(CoreDataError.taskNotFound(id: id)))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(CoreDataError.saveFailed(error)))
                }
            }
        }
    }

    func updateTask(withId id: Int, withTitle title: String, description: String, completion: @escaping (Result<Void, Error>) -> Void) {
        persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<TaskCoreDataEntity> = TaskCoreDataEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)

            do {
                if let taskToUpdate = try context.fetch(fetchRequest).first {
                    taskToUpdate.name = title
                    taskToUpdate.descriptions = description
                    try context.save()
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(CoreDataError.taskNotFound(id: id)))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(CoreDataError.saveFailed(error)))
                }
            }
        }
    }
}
