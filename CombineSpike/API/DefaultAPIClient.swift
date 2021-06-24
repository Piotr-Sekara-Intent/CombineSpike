//
//  DefaultAPIClient.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import Combine
import Foundation

final class DefaultAPIClient: APIClient {
    // MARK: - Properties

    private let environment: AppEnvironment

    private let session = URLSession(configuration: .default)

    // MARK: - Initializers

    init(environment: AppEnvironment) {
        self.environment = environment
    }

    // MARK: Core

    private func data(with request: URLRequest) -> AnyPublisher<Data, Error> {
        session.dataTaskPublisher(for: request).mapError { ApiError($0) }.tryMap { try self.validate($0, response: $1) }.eraseToAnyPublisher()
    }

    private func validate<T>(_ body: T, response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError(reason: .invalidResponse)
        }

        guard 200...399 ~= httpResponse.statusCode else {
            if httpResponse.statusCode == 401 {
                throw ApiError(reason: .authorizationFailed)
            } else {
                throw ApiError(reason: .invalidResponse)
            }
        }

        return body
    }

    private func get(url: URL, headers: [String: String] = [:], authorized: Bool = true) -> AnyPublisher<Data, Error> {
        data(with: URLRequest(url: url, method: "GET", headers: headers))
    }

    private func get(path: String, query: [String: String] = [:], headers: [String: String] = [:], authorized: Bool = true) -> AnyPublisher<Data, Error> {
        guard let url = URL(path: path, relativeTo: environment.apiBaseUrl, query: query) else { return Result.Publisher(ApiError(reason: .invalidRequest)).eraseToAnyPublisher() }
        return get(url: url, headers: headers, authorized: authorized)
    }

    // MARK: ApiClient

    func fetchBreeds() -> AnyPublisher<[Breed], Error> {
        get(path: "api/breeds/list/all").decode(type: BreedListResponse.self, decoder: JSONDecoder()).map { $0.breeds }.eraseToAnyPublisher()
    }

    func fetchBreedImageURL(for breed: String) -> AnyPublisher<String, Error> {
        let breedPath = breed.replacingOccurrences(of: " ", with: "/")
        return get(path: "api/breed/\(breedPath)/images/random").decode(type: BreedImageResponse.self, decoder: JSONDecoder()).map { $0.url }.eraseToAnyPublisher()
    }
}
