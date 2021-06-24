//
//  BreedListResponse.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import Foundation

struct BreedListResponse: Decodable {
    let status: String
    let breeds: [Breed]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(String.self, forKey: .status)
        breeds = try container.decode([String: [String]].self, forKey: .breeds).map { Breed(name: $0.key, subBreeds: $0.value)}
    }
}

private extension BreedListResponse {
    enum CodingKeys: String, CodingKey {
        case status
        case breeds = "message"
    }
}
