//
//  ApiError.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 3.08.25.
//

import Foundation

enum ApiError: LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL-адрес."
        case .requestFailed(let error):
            return "Ошибка сетевого запроса: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Ошибка декодирования данных: \(error.localizedDescription)"
        }
    }
}
