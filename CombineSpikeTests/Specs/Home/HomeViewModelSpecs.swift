//
//  HomeViewModelSpecs.swift
//  CombineSpikeTests
//
//  Created by Piotr on 24/06/2021.
//

import Nimble
import Quick
@testable import CombineSpike

final class HomeViewModelSpecs: QuickSpec {
    override func spec() {
        describe("HomeViewModel") {
            var sut: HomeViewModel!

            var mockAPIClient: MockAPIClient!
            var scheduler: TestScheduler!

            beforeEach {
                scheduler = .init()
                mockAPIClient = .init()
                sut = HomeViewModel(scheduler: scheduler.eraseToAnyScheduler(), apiClient: mockAPIClient)
            }

            describe("#loadBreeds") {
                describe("when breeds were loaded successfully") {
                    beforeEach {
                        mockAPIClient.fetchBreedsSubject.send([.init(name: "Maltese", subBreeds: [])])
                        sut.loadBreeds()
                    }

                    it("changes state to loaded") {
                        expect(sut.state.isLoaded).to(beTruthy())
                    }

                    it("saves loaded breeds") {
                        expect(sut.breeds.first!.name).to(equal("Maltese"))
                    }
                }

                describe("when breeds couldn't be loaded") {
                    beforeEach {
                        mockAPIClient.fetchBreedsSubject.send(completion: .failure(NSError(domain: "com.combinespike.error", code: 1, userInfo: nil)))
                        sut.loadBreeds()
                    }

                    it("changes state to failure") {
                        expect(sut.state.isFailure).to(beTruthy())
                    }

                    it("has empty breeds") {
                        expect(sut.breeds.isEmpty).to(beTruthy())
                    }
                }
            }

            describe("#loadImage(for:)") {
                describe("when there is an image for the given breed") {
                    beforeEach {
                        mockAPIClient.fetchBreedImageURLSubject.send("https://feature.com/image.png")
                        sut.loadImage(for: "Maltese")
                    }

                    it("saves breed image url") {
                        expect(sut.breedImageURL).to(equal(URL(string: "https://feature.com/image.png")))
                    }
                }

                describe("when there is no image for the given breed") {
                    beforeEach {
                        mockAPIClient.fetchBreedImageURLSubject.send(completion: .failure(NSError(domain: "com.combinespike.error", code: 1, userInfo: nil)))
                        sut.loadImage(for: "Maltese")
                    }

                    it("saves breed image url") {
                        expect(sut.breedImageURL).to(beNil())
                    }
                }
            }
        }
    }
}

// MARK: - Helpers

extension ViewState {
    var isFailure: Bool {
        switch self {
        case .failure:
            return true
        default:
            return false
        }
    }

    var isLoaded: Bool {
        switch self {
        case .loaded:
            return true
        default:
            return false
        }
    }
}
