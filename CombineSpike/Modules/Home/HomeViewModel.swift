//
//  HomeViewModel.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import Combine
import Foundation

final class HomeViewModel: ObservableObject {

    // MARK: - Properties

    @Published var breeds = [Breed]()
    @Published var breedImageURL: URL?
    @Published var state: ViewState = .loading

    private let apiClient: APIClient
    private let scheduler: AnyScheduler<DispatchQueue>
    private var cancelBag = CancelBag()

    // MARK: - Initializers

    init(scheduler: AnyScheduler<DispatchQueue> = .main, apiClient: APIClient) {
        self.scheduler = scheduler
        self.apiClient = apiClient
        loadBreeds()
    }

    // MARK: - Functions

    func loadBreeds() {
        apiClient.fetchBreeds()
            .receive(on: scheduler)
            .sink { [weak self] in
                switch $0 {
                case let .failure(error):
                    self?.state = .failure(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] in
                self?.breeds = $0.sorted { $0.name < $1.name }
                self?.state = .loaded
            }
            .store(in: cancelBag)
    }

    func loadImage(for breed: String) {
        let cancelBag = CancelBag()
        apiClient.fetchBreedImageURL(for: breed)
            .receive(on: scheduler)
            .sink { [weak self] in
                    switch $0 {
                    case let .failure(error):
                        self?.state = .failure(error)
                    case .finished:
                        break
                    }
            } receiveValue: { [weak self] in
                self?.breedImageURL = URL(string: $0)
            }
            .store(in: cancelBag)
    }
}
