//
//  Breed.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import Foundation

struct Breed {
    let name: String
    let subBreeds: [String]
}

extension Breed {
    var hasSubBreeds: Bool {
        !subBreeds.isEmpty
    }
}
