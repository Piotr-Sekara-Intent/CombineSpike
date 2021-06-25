//
//  DefaultAPIClientSpecs.swift
//  CombineSpikeTests
//
//  Created by Piotr on 24/06/2021.
//

import Combine
import Foundation
import Nimble
import Quick
@testable import CombineSpike

final class DefaultAPIClientSpecs: QuickSpec {
    override func spec() {
        describe("DefaultAPIClient") {
            var mockURLSession: MockURLSession!

            var sut: DefaultAPIClient!

            beforeEach {
                mockURLSession = .init()
                sut = DefaultAPIClient(environment: MockAppEnvironment(), session: mockURLSession)
            }

            describe("#fetchBreeds") {
                var breeds: [Breed]!

                beforeEach {
                    breeds = []

                    let breedsResponse = BreedListResponse(status: "success", breeds: [
                        .init(name: "Maltese", subBreeds: []),
                        .init(name: "Akita", subBreeds: [])
                    ])
                    mockURLSession.stubbedPublisher = Result.Publisher(try! JSONEncoder().encode(breedsResponse)).eraseToAnyPublisher()

                    _ = sut.fetchBreeds()
                        .sink { _ in
                        } receiveValue: {
                            breeds = $0
                        }
                }

                it("has correct request url path") {
                    expect(mockURLSession.sentRequest?.url?.path).to(equal("/api/breeds/list/all"))
                }

                it("returns correct breeds") {
                    expect(breeds.first(where: { $0.name == "Akita"})).toNot(beNil())
                }
            }

            describe("#fetchBreedImageURL(for:)") {
                var imageURL: String!

                beforeEach {
                    imageURL = ""

                    let breedImageResponse = BreedImageResponse(status: "success", url: "https://feature.com/breeds/hound-afghan/n02088094_4219.jpg")
                    mockURLSession.stubbedPublisher = Result.Publisher(try! JSONEncoder().encode(breedImageResponse)).eraseToAnyPublisher()

                    _ = sut.fetchBreedImageURL(for: "australian shepherd")
                        .sink { _ in
                        } receiveValue: {
                            imageURL = $0
                        }
                }

                it("has correct request url path") {
                    expect(mockURLSession.sentRequest?.url?.path).to(equal("/api/breed/australian/shepherd/images/random"))
                }

                it("returns correct image url") {
                    expect(imageURL).to(equal("https://feature.com/breeds/hound-afghan/n02088094_4219.jpg"))
                }
            }
        }
    }
}
