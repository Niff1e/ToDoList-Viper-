//
//  JSONManager.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 23.01.25.
//

import Foundation

final class JSONManager: NetworkServiceProtocol {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Get To Do Items

    func fetchTasks(completion: @escaping (Result<DummyJSONResponse, Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(ApiError.invalidURL))
            return
        }

        let task = self.session.dataTask(with: url) { data, _, error in
            if let error = error {
                 completion(.failure(ApiError.requestFailed(error)))
                 return
             }

            guard let data = data else {
                let unknownError = NSError(domain: "NetworkError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не получены данные от сервера."])
                completion(.failure(ApiError.requestFailed(unknownError)))
                return
            }

            do {
                let json = try JSONDecoder().decode(DummyJSONResponse.self, from: data)
                completion(.success(json))
            } catch {
                completion(.failure(ApiError.decodingFailed(error)))
            }
        }
        task.resume()
    }
}
