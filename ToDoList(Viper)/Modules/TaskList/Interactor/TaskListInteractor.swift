//
//  TaskListInteractor.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 23.01.25.
//

import Foundation

class TaskListInteractor: TaskListInteractorProtocol {
    weak var presenter: TaskListPresenterProtocol?

    // MARK: - Fetching data from CoreData

    func fetchTasks() {
        let localTasks = CoreDataManager.shared.fetchTasksFromCoreData()
        if !localTasks.isEmpty {
            let tasks = localTasks.map { TaskEntity(title: $0.name ?? "", description: $0.descriptions ?? "", dueDate: $0.date ?? Date(), isCompleted: $0.completed) }
            presenter?.didFetchTasks(tasks)
        } else {
            JSONManager.shared.fetchTasks { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let tasks):
                        let taskForCoreData = tasks.todos.map {
                            TaskEntity(title: $0.todo, description: $0.todo, dueDate: Date(), isCompleted: $0.completed)
                        }
                        CoreDataManager.shared.saveTasksToCoreData(taskForCoreData)
                        self?.presenter?.didFetchTasks(taskForCoreData)
                    case .failure(let error):
                        self?.presenter?.didFailToFetchTasks(error: error)
                    }
                }
            }
        }
    }

    // MARK: - Interaction with Tasks in CoreData

    func updateTaskStatus(task: TaskEntity) {
        CoreDataManager.shared.markTaskAsCompleted(task: task) { [weak self] result in
            switch result {
            case .success():
                break
            case .failure(let error):
                self?.presenter?.didFailToUpdateTask(error: error)
            }
        }
    }

    func addTask(_ task: TaskEntity) {
        CoreDataManager.shared.saveTasksToCoreData([task])
        fetchTasks()
    }

    func deleteTask(_ task: TaskEntity) {
        CoreDataManager.shared.deleteTask(task: task) { [weak self] result in
            switch result {
            case .success:
                self?.fetchTasks() // Перезагружаем данные после удаления
            case .failure(let error):
                self?.presenter?.didFailToDeleteTask(error: error)
            }
        }
    }
}
