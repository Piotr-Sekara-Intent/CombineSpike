//
//  URLSession.swift
//  CombineSpike
//
//  Created by Piotr on 25/06/2021.
//

import Combine
import Foundation

extension URLSession: URLSessionProtocol {
    func data(with request: URLRequest) -> AnyPublisher<Data, Error> {
        dataTaskPublisher(for: request).mapError { ApiError($0) }.tryMap { try self.validate($0, response: $1) }.eraseToAnyPublisher()
    }

    func validate<T>(_ body: T, response: URLResponse) throws -> T {
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
}
