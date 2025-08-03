//
//  NetworkServiceProtocol.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 31.07.25.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchTasks(completion: @escaping (Result<DummyJSONResponse, Error>) -> Void)
}
