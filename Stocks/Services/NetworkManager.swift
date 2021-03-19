//
//  NetworkManager.swift
//  Stocks
//
//  Created by Scott on 3/4/21.
//

import Foundation

enum NetworkError: Error {
    case error(err: String)
    case invalidResponse(response: String)
    case invalidData
    case decodingError(err: String)
}

final class NetworkManager<T: Codable> {
    func fetch(from url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.error(err: error!.localizedDescription)))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let json = try JSONDecoder().decode(T.self, from: data)
                completion(.success(json))
            } catch {
                completion(.failure(.decodingError(err: error.localizedDescription)))
                print(error)
            }
        }.resume()
    }
}
