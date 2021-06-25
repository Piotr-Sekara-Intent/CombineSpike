//
//  URLSessionProtocol.swift
//  CombineSpike
//
//  Created by Piotr on 25/06/2021.
//

import Combine
import Foundation

protocol URLSessionProtocol {
    func data(with request: URLRequest) -> AnyPublisher<Data, Error>
}
