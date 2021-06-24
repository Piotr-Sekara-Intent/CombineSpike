//
//  MockAPIClient.swift
//  CombineSpikeTests
//
//  Created by Piotr on 24/06/2021.
//

import Combine
@testable import CombineSpike

final class MockAPIClient: APIClient {

    var fetchBreedsSubject = PassthroughSubject<[Breed], Error>()
    var fetchBreedImageURLSubject = CurrentValueSubject<String, Error>("")

    func fetchBreeds() -> AnyPublisher<[Breed], Error> {
        fetchBreedsSubject.eraseToAnyPublisher()
    }

    func fetchBreedImageURL(for breed: String) -> AnyPublisher<String, Error> {
        fetchBreedImageURLSubject.eraseToAnyPublisher()
    }
}
