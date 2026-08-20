//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Valentin Medvedev on 10.08.2024.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

enum NetworkError: LocalizedError {
    case codeError
    case emptyData
    
    var errorDescription: String? {
        switch self {
        case .codeError:
            return "Ошибка ответа сервера"
        case .emptyData:
            return "Пустой ответ сервера"
        }
    }
}

struct NetworkClient: NetworkRouting {
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data = data, !data.isEmpty else {
                handler(.failure(NetworkError.emptyData))
                return
            }
            
            handler(.success(data))
        }
        
        task.resume()
    }
}
