//
//  MocksTaskEditor.swift
//  ToDoList(Viper)Tests
//
//  Created by Pavel Maal on 4.08.25.
//

import Foundation
@testable import ToDoList_Viper_

class MockTaskEditorView: TaskEditorViewProtocol {
    var presenter: TaskEditorPresenterProtocol?
    var isShowErrorCalled = false

    func showError(title: String, message: String) {
        isShowErrorCalled = true
    }
}

class MockTaskEditorInteractor: TaskEditorInteractorProtocol {
    var presenter: TaskEditorPresenterProtocol?
    var isSaveTaskCalled = false

    func saveTaskInCoreData(title: String, description: String, completion: @escaping (Result<TaskEntity, Error>) -> Void) {
        isSaveTaskCalled = true
    }

    func updateTask(withId id: Int, newTitle: String, newDescription: String, completion: @escaping (Result<Void, Error>) -> Void) {
    }
}

class MockTaskEditorRouter: TaskEditorRouterProtocol {
    var isDismissCalled = false

    func dismiss() {
        isDismissCalled = true
    }
}
