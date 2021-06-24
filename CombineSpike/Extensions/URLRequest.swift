//
//  URLRequest.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import Foundation

extension URLRequest {
    init(url: URL, method: String, headers: [String: String] = [:], body: Data? = nil) {
        self.init(url: url)
        httpMethod = method
        allHTTPHeaderFields = headers
        httpBody = body
    }
}
