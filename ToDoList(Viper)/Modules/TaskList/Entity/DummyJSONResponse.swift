//
//  DummyJSONResponse.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 23.01.25.
//

import Foundation

struct DummyJSONResponse: Codable {
    let todos: [ToDoItem]
    let total: Int
    let skip: Int
    let limit: Int
}

struct ToDoItem: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
