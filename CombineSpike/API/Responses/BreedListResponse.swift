//
//  BreedListResponse.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import Foundation

struct BreedListResponse: Codable {
    let status: String
    let breeds: [Breed]

    init(status: String, breeds: [Breed]) {
        self.status = status
        self.breeds = breeds
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(String.self, forKey: .status)
        breeds = try container.decode([String: [String]].self, forKey: .breeds).map { Breed(name: $0.key, subBreeds: $0.value)}
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        let breedsDict = breeds.reduce([String: [String]]()) { dict, breed in
            var dict = dict
            dict[breed.name] = breed.subBreeds
            return dict
        }
        try container.encode(breedsDict, forKey: .breeds)
    }
}

private extension BreedListResponse {
    enum CodingKeys: String, CodingKey {
        case status
        case breeds = "message"
    }
}
