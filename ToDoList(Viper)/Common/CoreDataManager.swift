//
//  CoreDataManager.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 23.01.25.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {

    static let shared = CoreDataManager()
    private let persistentContainer: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer

    func saveTasksToCoreData(_ tasks: [TaskEntity]) {
        let context = persistentContainer.viewContext
        tasks.forEach { task in
            let taskObject = TaskCoreDataEntity(context: context)
            taskObject.name = task.title
            taskObject.descriptions = task.description
            taskObject.completed = task.isCompleted
            taskObject.date = task.dueDate
        }
        do {
            try context.save()
        } catch {
            print("Failed to save tasks to CoreData: \(error)")
        }
    }

    func saveTaskToCoreData(_ task: TaskEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = persistentContainer.viewContext
        let taskObject = TaskCoreDataEntity(context: context)
        taskObject.name = task.title
        taskObject.descriptions = task.description
        taskObject.completed = task.isCompleted
        taskObject.date = task.dueDate
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print("Failed to save task to CoreData: \(error)")
            completion(.failure(error))
        }
    }

    func markTaskAsCompleted(task: TaskEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = persistentContainer.viewContext  // Получаем контекст
        let fetchRequest: NSFetchRequest<TaskCoreDataEntity> = TaskCoreDataEntity.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "name == %@ AND date == %@", task.title, task.dueDate as CVarArg)

        do {
            let tasks = try context.fetch(fetchRequest)
            if let task = tasks.first {
                task.completed.toggle()
                try context.save()
                completion(.success(()))
            } else {
                completion(.failure(NSError()))
                print("Task not found with the given title and due date.")
            }
        } catch {
            completion(.failure(error))
            print("Error fetching or saving task: \(error)")
        }
    }

    func fetchTasksFromCoreData() -> [TaskCoreDataEntity] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskCoreDataEntity> = TaskCoreDataEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch tasks from CoreData: \(error)")
            return []
        }
    }

    func deleteTask(task: TaskEntity, completion: (Result<Void, Error>) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskCoreDataEntity> = TaskCoreDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND date == %@", task.title, task.dueDate as CVarArg)

        do {
            if let taskToDelete = try context.fetch(fetchRequest).first {
                context.delete(taskToDelete)
                try context.save()
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "Task not found", code: 404, userInfo: nil)))
            }
        } catch {
            print("Failed to delete task: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }

    func update(task: TaskEntity, withTitle title: String, description: String, completion: (Result<Void, Error>) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskCoreDataEntity> = TaskCoreDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND date == %@", task.title, task.dueDate as CVarArg)

        do {
            if let taskToUpdate = try context.fetch(fetchRequest).first {
                taskToUpdate.name = title
                taskToUpdate.descriptions = description
                try context.save()
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
            print("Failed to update task: \(error.localizedDescription)")
        }
    }
}
