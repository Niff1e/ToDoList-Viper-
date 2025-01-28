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
    func showError(_ message: String)
}

protocol TaskListPresenterProtocol: AnyObject {
    var view: TaskListViewProtocol? { get set }
    var interactor: TaskListInteractorProtocol? { get set }
    var router: TaskListRouterProtocol? { get set }

    func viewDidLoad()
    func didFetchTasks(_ tasks: [TaskEntity])
    func didFailToFetchTasks(error: Error)
    func addTask()
    func editTask(_ task: TaskEntity)
    func deleteTask(_ task: TaskEntity)
    func toggleTaskCompletion(task: TaskEntity)
    func didFailToUpdateTask(error: Error)
    func didFailToDeleteTask(error: Error)
}

protocol TaskListInteractorProtocol: AnyObject {
    var presenter: TaskListPresenterProtocol? { get set }
    func fetchTasks()
    func addTask(_ task: TaskEntity)
    func deleteTask(_ task: TaskEntity)
    func updateTaskStatus(task: TaskEntity)
}

protocol TaskListRouterProtocol: AnyObject {
    var viewController: TaskListViewController? { get set }
    static func createModule() -> TaskListViewController
    func navigateToAddTask(completion: @escaping (Result<Void, Error>) -> Void)
    func navigateToTaskDetails(with task: TaskEntity, completion: @escaping (Result<Void, Error>) -> Void)
}
