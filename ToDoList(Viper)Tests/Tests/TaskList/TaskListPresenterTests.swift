//
//  TaskListPresenterTests.swift
//  ToDoList(Viper)Tests
//
//  Created by Pavel Maal on 4.08.25.
//

import XCTest
@testable import ToDoList_Viper_

final class TaskListPresenterTests: XCTestCase {

    var presenter: TaskListPresenter!
    var view: MockTaskListView!
    var interactor: MockTaskListInteractor!
    var router: MockTaskListRouter!

    override func setUp() {
        super.setUp()
        view = MockTaskListView()
        interactor = MockTaskListInteractor()
        router = MockTaskListRouter()
        presenter = TaskListPresenter()

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

    func test_viewDidLoad_shouldAskInteractorToFetchTasks() {
        presenter.viewDidLoad()
        XCTAssertTrue(interactor.isFetchTasksCalled, "После viewDidLoad() presenter должен был вызвать interactor.fetchTasks(), но этого не произошло.")
    }

    func test_searchTasks_withValidQuery_shouldUpdateViewWithFilteredTasks() {
        let tasks = [
            TaskEntity(id: 1, title: "Купить молоко", description: "", dueDate: Date(), isCompleted: false),
            TaskEntity(id: 2, title: "Выучить Swift", description: "", dueDate: Date(), isCompleted: false),
            TaskEntity(id: 3, title: "Купить хлеб", description: "", dueDate: Date(), isCompleted: false)
        ]

        presenter.didFetchTasks(tasks)
        view.isUpdateTaskListCalled = false

        let searchQuery = "Купить"

        presenter.searchTasks(with: searchQuery)

        XCTAssertTrue(view.isUpdateTaskListCalled, "View.updateTaskList() должен был быть вызван после поиска.")
        XCTAssertEqual(view.receivedTasks?.count, 2, "Во View должно было быть передано 2 отфильтрованные задачи.")
        XCTAssertEqual(view.receivedTasks?.first?.title, "Купить молоко", "Первая отфильтрованная задача должна быть 'Купить молоко'.")
    }

    func test_searchTasks_withEmptyQuery_shouldUpdateViewWithAllTasks() {
        let tasks = [
            TaskEntity(id: 1, title: "Купить молоко", description: "", dueDate: Date(), isCompleted: false),
            TaskEntity(id: 2, title: "Выучить Swift", description: "", dueDate: Date(), isCompleted: false),
            TaskEntity(id: 3, title: "Купить хлеб", description: "", dueDate: Date(), isCompleted: false)
        ]

        presenter.didFetchTasks(tasks)
        view.isUpdateTaskListCalled = false

        presenter.searchTasks(with: "")

        XCTAssertEqual(view.receivedTasks?.count, 3, "Во View должно было быть передано 3 задачи.")
    }

    func test_cancelSearch_shouldUpdateViewWithAllTasks() {
        let tasks = [
            TaskEntity(id: 1, title: "Купить молоко", description: "", dueDate: Date(), isCompleted: false),
            TaskEntity(id: 2, title: "Выучить Swift", description: "", dueDate: Date(), isCompleted: false),
            TaskEntity(id: 3, title: "Купить хлеб", description: "", dueDate: Date(), isCompleted: false)
        ]

        presenter.didFetchTasks(tasks)

        let searchQuery = "Купить"

        presenter.searchTasks(with: searchQuery)
        view.isUpdateTaskListCalled = false

        presenter.cancelSearch()

        XCTAssertTrue(view.isUpdateTaskListCalled, "View.updateTaskList() должен был быть вызван после отмены поиска.")
        XCTAssertEqual(view.receivedTasks?.count, 3, "Во View должно было быть передано 3 задачи.")
    }
}
