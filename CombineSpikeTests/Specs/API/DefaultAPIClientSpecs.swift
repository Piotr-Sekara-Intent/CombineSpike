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
            var sut: DefaultAPIClient!

            beforeEach {
                sut = DefaultAPIClient(environment: MockAppEnvironment(), sessionConfiguration: .mock)
            }

            describe("#fetchBreeds") {
                var breeds: [Breed]!
                var cancelBag: CancelBag!

                beforeEach {
                    breeds = []
                    cancelBag = CancelBag()
                    MockURLProtocol.mockedURLs = [
                        URL(string: "https://feature.com/api/breeds/list/all")!: try! JSONEncoder().encode(BreedListResponse(status: "success", breeds: [.init(name: "Test", subBreeds: []), .init(name: "Test2", subBreeds: ["Test3"])]))
                    ]

                    let validResponse = HTTPURLResponse(url: URL(string: "https://feature.com/api/breeds/list/all")!,
                                                            statusCode: 200,
                                                            httpVersion: nil,
                                                            headerFields: nil)

                    MockURLProtocol.mockedResponse = validResponse

                    sut.fetchBreeds()
                        .sink { completion in
                            print(completion)
                        } receiveValue: {
                            breeds = $0
                        }
                        .store(in: cancelBag)
                }

                it("") {
                    expect(breeds.isEmpty).to(beTruthy())
                }
            }
        }
    }
}
