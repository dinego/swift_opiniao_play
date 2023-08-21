//
//  ConfigService.swift
//  opiniaoplay
//
//  Created by Diego Moreira on 20/08/23.
//

import Foundation

struct Config: Codable {
    let id: Int
    let urlStream: String
    // Other properties...
}

class ConfigService: ObservableObject {
    static let shared = ConfigService()

    private var config: Config?

    private init() {}

    func fetchConfig(completion: @escaping (Result<Config, Error>) -> Void) {
        guard let url = URL(string: "http://opiniaochat.com.br.hulk.hostazul.com.br/api/Configuracao") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let configurations = try JSONDecoder().decode([Config].self, from: data)
                    if let firstConfig = configurations.first {
                        self.config = firstConfig
                        completion(.success(firstConfig))
                    } else {
                        completion(.failure(NSError(domain: "No configuration found", code: 0, userInfo: nil)))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    func getConfig() -> Config? {
        return config
    }
}
