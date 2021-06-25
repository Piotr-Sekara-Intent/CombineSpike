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

    private let session: URLSessionProtocol

    // MARK: - Initializers

    init(environment: AppEnvironment, session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.environment = environment
        self.session = session
    }

    // MARK: Core

    private func get(url: URL, headers: [String: String] = [:], authorized: Bool = true) -> AnyPublisher<Data, Error> {
        session.data(with: URLRequest(url: url, method: "GET", headers: headers))
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
