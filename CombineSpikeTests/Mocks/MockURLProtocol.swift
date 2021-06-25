//
//  MockURLProtocol.swift
//  CombineSpikeTests
//
//  Created by Piotr on 24/06/2021.
//

import Combine
import Foundation

final class MockURLProtocol: URLProtocol {
    static var mockedURLs = [URL?: Data]()
    static var mockedResponse: URLResponse?
    static var mockedError: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        if let url = request.url {
            if let data = MockURLProtocol.mockedURLs[url] {
                client?.urlProtocol(self, didLoad: data)
            }
        }

        if let response = MockURLProtocol.mockedResponse {
            client?.urlProtocol(self,
                                     didReceive: response,
                                     cacheStoragePolicy: .notAllowed)
        }

        if let error = MockURLProtocol.mockedError {
            client?.urlProtocol(self, didFailWithError: error)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}

extension URLSessionConfiguration {
    static var mock: URLSessionConfiguration {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return config
    }
}
