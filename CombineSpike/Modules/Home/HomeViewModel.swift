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

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializers

    init(apiClient: APIClient) {
        self.apiClient = apiClient
        loadBreeds()
    }

    // MARK: - Functions

    func loadBreeds() {
        apiClient.fetchBreeds()
            .receive(on: DispatchQueue.main)
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
            .store(in: &cancellables)
    }

    func loadImage(for breed: String) {
        apiClient.fetchBreedImageURL(for: breed)
            .receive(on: DispatchQueue.main)
            .sink { _ in

            } receiveValue: { [weak self] in
                self?.breedImageURL = URL(string: $0)
            }
            .store(in: &cancellables)
    }
}
