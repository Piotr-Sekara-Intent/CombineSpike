//
//  BreedImageResponse.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import Foundation

struct BreedImageResponse: Codable {
    let status: String
    let url: String
}

private extension BreedImageResponse {
    enum CodingKeys: String, CodingKey {
        case status
        case url = "message"
    }
}
