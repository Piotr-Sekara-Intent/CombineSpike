//
//  APIClient.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import Combine
import Foundation

protocol APIClient {
    func fetchBreeds() -> AnyPublisher<[Breed], Error>
    func fetchBreedImageURL(for breed: String) -> AnyPublisher<String, Error>
}
