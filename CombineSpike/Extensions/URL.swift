//
//  URL.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import Foundation

extension URL {
    init?(path: String, relativeTo base: URL, query: [String: String]) {

        guard let relativeUrl = URL(string: path, relativeTo: base) else { return nil }

        let comps = with(URLComponents(url: relativeUrl, resolvingAgainstBaseURL: true)!) {
            guard !query.isEmpty else { return }
            $0.queryItems = query.map { URLQueryItem(name: $0, value: $1) }
        }

        guard let builtUrl = comps.url else { return nil }
        self = builtUrl
    }
}
