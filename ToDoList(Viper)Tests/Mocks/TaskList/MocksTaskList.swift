//
//  MocksTaskList.swift
//  ToDoList(Viper)Tests
//
//  Created by Pavel Maal on 4.08.25.
//

import Foundation
@testable import ToDoList_Viper_
import CoreData

class MockTaskListView: TaskListViewProtocol {
    var presenter: (any TaskListPresenterProtocol)?

    var isUpdateTaskListCalled = false
    var isShowErrorCalled = false
    var receivedTasks: [TaskEntity]?

    func updateTaskList(_ tasks: [TaskEntity]) {
        isUpdateTaskListCalled = true
        receivedTasks = tasks
    }

    func showError(title: String, message: String) {
        isShowErrorCalled = true
    }
}

class MockTaskListInteractor: TaskListInteractorProtocol {
    var presenter: (any TaskListPresenterProtocol)?

    var isFetchTasksCalled = false

    func fetchTasks() {
        isFetchTasksCalled = true
    }

    func deleteTask(withId id: Int) {
    }

    func updateTaskStatus(forId id: Int) {
    }
}

class MockTaskListRouter: TaskListRouterProtocol {
    var viewController: TaskListViewController?

    func navigateToAddTask(completion: @escaping (TaskEntity) -> Void) {}
    func navigateToTaskDetails(with task: TaskEntity, completion: @escaping (TaskEntity) -> Void) {}
}

class MockTaskListPresenter: TaskListPresenterProtocol {
    var didFetchTasksCalled = false
    var didFailCalled = false

    var view: (any TaskListViewProtocol)?
    var interactor: (any TaskListInteractorProtocol)?
    var router: (any TaskListRouterProtocol)?
    func viewDidLoad() {}
    func didFetchTasks(_ tasks: [TaskEntity]) { didFetchTasksCalled = true }
    func didFail(with error: Error) { didFailCalled = true }
    func addTask() {}
    func editTask(_ task: TaskEntity) {}
    func deleteTask(withId id: Int) {}
    func didSucceedToDelete(withId id: Int) {}
    func toggleTaskCompletion(forId id: Int) {}
    func didSucceedToUpdateStatus(forId id: Int) {}
    func searchTasks(with query: String) {}
    func cancelSearch() {}
}

class MockNetworkService: NetworkServiceProtocol {
    var isFetchTasksCalled = false

    var fetchTasksResult: Result<DummyJSONResponse, Error> = .success(DummyJSONResponse(todos: [], total: 0, skip: 0, limit: 0))

    func fetchTasks(completion: @escaping (Result<DummyJSONResponse, Error>) -> Void) {
        isFetchTasksCalled = true
        completion(fetchTasksResult)
    }
}

class MockCoreDataManager: CoreDataManager {
    init() {
        super.init(persistentContainer: NSPersistentContainer(name: "Fake"))
    }

    var isFetchTasksCalled = false
    var tasksToReturn: [TaskCoreDataEntity] = []

    override func fetchTasksFromCoreData() -> [TaskCoreDataEntity] {
        isFetchTasksCalled = true
        return tasksToReturn
    }
}
