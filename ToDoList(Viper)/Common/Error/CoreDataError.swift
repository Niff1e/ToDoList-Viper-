//
//  CoreDataError.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 3.08.25.
//

import Foundation

enum CoreDataError: LocalizedError {
    case saveFailed(Error)
    case taskNotFound(id: Int)
    case fetchFailed(Error)

    var errorDescription: String? {
        switch self {
        case .saveFailed(let underlyingError):
            return "Не удалось сохранить данные: \(underlyingError.localizedDescription)"
        case .taskNotFound(let id):
            return "Задача с ID \(id) не найдена."
        case .fetchFailed(let underlyingError):
            return "Не удалось загрузить данные: \(underlyingError.localizedDescription)"
        }
    }
}
