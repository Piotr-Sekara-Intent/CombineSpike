//
//  MockURLSession.swift
//  CombineSpikeTests
//
//  Created by Piotr on 25/06/2021.
//

import Combine
import Foundation
@testable import CombineSpike

class MockURLSession: URLSessionProtocol {
    var sentRequest: URLRequest?
    var stubbedPublisher: AnyPublisher<Data, Error>?

    func data(with request: URLRequest) -> AnyPublisher<Data, Error> {
        sentRequest = request
        guard let stubbedPublisher = stubbedPublisher else {
            return Result.Publisher(ApiError(reason: .unknown)).eraseToAnyPublisher()
        }
        return stubbedPublisher
    }
}
