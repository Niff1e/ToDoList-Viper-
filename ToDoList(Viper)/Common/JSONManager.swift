//
//  JSONManager.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 23.01.25.
//

import Foundation
import UIKit

enum ApiError: Error {
    case invalidURL
    case failedToGetData
    case failedToDecodeJSON
}

final class JSONManager {

    static let shared = JSONManager()

    // MARK: - Get To Do Items

    func fetchTasks(completion: @escaping (Result<DummyJSONResponse, Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(ApiError.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data, error == nil else {
                completion(.failure(ApiError.failedToGetData))
                return
            }
            do {
                let json = try JSONDecoder().decode(DummyJSONResponse.self, from: data)
                completion(.success(json))
            } catch {
                completion(.failure(ApiError.failedToDecodeJSON))
            }
        }
        task.resume()
    }
}
