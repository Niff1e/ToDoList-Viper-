//
//  TaskListInteractor.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 23.01.25.
//

import Foundation

final class TaskListInteractor: TaskListInteractorProtocol {
    weak var presenter: TaskListPresenterProtocol?
    private let networkService: NetworkServiceProtocol
    private let coreDataManager: CoreDataManager

    init(presenter: TaskListPresenterProtocol? = nil, networkService: NetworkServiceProtocol, coreDataManager: CoreDataManager) {
        self.networkService = networkService
        self.coreDataManager = coreDataManager
    }

    // MARK: - Fetching data from CoreData

    func fetchTasks() {
        let localTasks = coreDataManager.fetchTasksFromCoreData()
        if !localTasks.isEmpty {
            let tasks = localTasks.map { TaskEntity(id: Int($0.id), title: $0.name ?? "", description: $0.descriptions ?? "", dueDate: $0.date ?? Date(), isCompleted: $0.completed) }
            presenter?.didFetchTasks(tasks)
        } else {
            networkService.fetchTasks { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let tasks):
                        let taskForCoreData = tasks.todos.map {
                            TaskEntity(id: $0.id, title: $0.todo, description: $0.todo, dueDate: Date(), isCompleted: $0.completed)
                        }
                        self?.coreDataManager.saveTasksToCoreData(taskForCoreData)
                        self?.presenter?.didFetchTasks(taskForCoreData)
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.presenter?.didFail(with: error)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Interaction with Tasks in CoreData

    func updateTaskStatus(forId id: Int) {
        coreDataManager.toggleTaskStatus(withId: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.presenter?.didSucceedToUpdateStatus(forId: id)
                case .failure(let error):
                    self?.presenter?.didFail(with: error)
                }
            }
        }
    }

    func deleteTask(withId id: Int) {
        coreDataManager.deleteTask(withId: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.presenter?.didSucceedToDelete(withId: id)
                case .failure(let error):
                    self?.presenter?.didFail(with: error)
                }
            }
        }
    }
}
