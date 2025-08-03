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
    func showError(title: String, message: String)
}

protocol TaskEditorPresenterProtocol: AnyObject {
    var view: TaskEditorViewProtocol? { get set }
    var interactor: TaskEditorInteractorProtocol? { get set }
    var router: TaskEditorRouterProtocol? { get set }

    func saveTask(title: String, description: String)
    func updateTask(withId id: Int, newTitle: String, newDescription: String)
}

protocol TaskEditorInteractorProtocol: AnyObject {
    var presenter: TaskEditorPresenterProtocol? { get set }
    func saveTaskInCoreData(title: String, description: String, completion: @escaping (Result<TaskEntity, Error>) -> Void)
    func updateTask(withId id: Int, newTitle: String, newDescription: String, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol TaskEditorRouterProtocol: AnyObject {
    func dismiss()
}

