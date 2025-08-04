//
//  TaskEditorPresenterTests.swift
//  ToDoList(Viper)Tests
//
//  Created by Pavel Maal on 4.08.25.
//

import XCTest
@testable import ToDoList_Viper_

final class TaskEditorPresenterTests: XCTestCase {

    var presenter: TaskEditorPresenter!
    var view: MockTaskEditorView!
    var interactor: MockTaskEditorInteractor!
    var router: MockTaskEditorRouter!

    override func setUp() {
        super.setUp()
        view = MockTaskEditorView()
        interactor = MockTaskEditorInteractor()
        router = MockTaskEditorRouter()

        presenter = TaskEditorPresenter(task: nil)

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
    }

    override func tearDown() {
        presenter = nil
        view = nil
        interactor = nil
        router = nil
        super.tearDown()
    }

    func test_saveTask_withEmptyTitle_shouldDismissWithoutSaving() {
        let emptyTitle = "   "
        let description = "Some description"

        presenter.saveTask(title: emptyTitle, description: description)

        XCTAssertFalse(interactor.isSaveTaskCalled, "Interactor.saveTaskInCoreData не должен был вызываться для задачи с пустым названием.")
        XCTAssertTrue(router.isDismissCalled, "Router.dismiss должен был быть вызван, чтобы закрыть экран.")
    }
}
