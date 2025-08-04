//
//  TaskListInteractorTests.swift
//  ToDoList(Viper)Tests
//
//  Created by Pavel Maal on 4.08.25.
//

import XCTest
@testable import ToDoList_Viper_

final class TaskListInteractorTests: XCTestCase {

    var interactor: TaskListInteractor!
    var presenter: MockTaskListPresenter!
    var networkService: MockNetworkService!
    var coreDataManager: MockCoreDataManager!

    override func setUp() {
        super.setUp()
        presenter = MockTaskListPresenter()
        networkService = MockNetworkService()
        coreDataManager = MockCoreDataManager()

        interactor = TaskListInteractor(
            networkService: networkService,
            coreDataManager: coreDataManager
        )
        interactor.presenter = presenter
    }

    override func tearDown() {
        interactor = nil
        presenter = nil
        networkService = nil
        coreDataManager = nil
        super.tearDown()
    }

    func test_fetchTasks_whenLocalDataIsEmpty_shouldRequestNetwork() {
        coreDataManager.tasksToReturn = []

        // 2. Настраиваем мок сети, чтобы он возвращал успешный, но пустой ответ.
        let dummyResponse = DummyJSONResponse(todos: [], total: 0, skip: 0, limit: 0)
        networkService.fetchTasksResult = .success(dummyResponse)

        interactor.fetchTasks()


        XCTAssertTrue(coreDataManager.isFetchTasksCalled, "Interactor должен был сначала запросить данные из CoreData.")

        XCTAssertTrue(networkService.isFetchTasksCalled, "Если в CoreData нет данных, Interactor должен запросить их из сети.")

        let expectation = XCTestExpectation(description: "Presenter.didFetchTasks should be called")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.presenter.didFetchTasksCalled, "Presenter.didFetchTasks должен был быть вызван в итоге.")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
