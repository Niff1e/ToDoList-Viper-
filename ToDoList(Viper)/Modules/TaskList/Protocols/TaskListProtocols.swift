//
//  TaskListProtocols.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 23.01.25.
//

import Foundation
import UIKit

protocol TaskListViewProtocol: AnyObject {
    var presenter: TaskListPresenterProtocol? { get set }
    func updateTaskList(_ tasks: [TaskEntity])
    func showError(title: String, message: String)
}

protocol TaskListPresenterProtocol: AnyObject {
    var view: TaskListViewProtocol? { get set }
    var interactor: TaskListInteractorProtocol? { get set }
    var router: TaskListRouterProtocol? { get set }

    func viewDidLoad()
    func didFetchTasks(_ tasks: [TaskEntity])
    func didFail(with error: Error)
    func addTask()
    func editTask(_ task: TaskEntity)
    func deleteTask(withId id: Int)
    func didSucceedToDelete(withId id: Int)
    func toggleTaskCompletion(forId id: Int)
    func didSucceedToUpdateStatus(forId id: Int)
    func searchTasks(with query: String)
    func cancelSearch()
}

protocol TaskListInteractorProtocol: AnyObject {
    var presenter: TaskListPresenterProtocol? { get set }
    func fetchTasks()
    func deleteTask(withId id: Int)
    func updateTaskStatus(forId id: Int)
}

protocol TaskListRouterProtocol: AnyObject {
    var viewController: TaskListViewController? { get set }
    func navigateToAddTask(completion: @escaping (TaskEntity) -> Void)
    func navigateToTaskDetails(with task: TaskEntity, completion: @escaping (TaskEntity) -> Void)
}
