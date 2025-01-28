//
//  TaskEditorProtocols.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 27.01.25.
//

import Foundation
import UIKit

protocol TaskEditorViewProtocol: AnyObject {
    var presenter: TaskEditorPresenterProtocol? { get set }
    var onTaskListUpdate: ((Result<Void, Error>) -> Void)? { get set }
}

protocol TaskEditorPresenterProtocol: AnyObject {
    var view: TaskEditorViewProtocol? { get set }
    var interactor: TaskEditorInteractorProtocol? { get set }
    var router: TaskEditorRouterProtocol? { get set }

    func saveTask(title: String, description: String)
    func update(task: TaskEntity, withTitle title: String, description: String)
}

protocol TaskEditorInteractorProtocol: AnyObject {
    var presenter: TaskEditorPresenterProtocol? { get set }
    func saveTaskInCoreData(title: String, description: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateTaskInCoreData(task: TaskEntity, withTitle title: String, description: String, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol TaskEditorRouterProtocol: AnyObject {
    static func createModule(with: TaskEntity?) -> TaskEditorViewController
}

