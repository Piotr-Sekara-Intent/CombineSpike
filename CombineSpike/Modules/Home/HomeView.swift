//
//  HomeView.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import Kingfisher
import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        switch viewModel.state {
        case .loading:
            Text("Loading breeds list.")
        case let .failure(error):
            Text("Sorry, error has occured. \(error.humanReadableDescription)")
        case .loaded:
            VStack {
                KFImage(viewModel.breedImageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                List {
                    ForEach(viewModel.breeds.indices, id: \.self) { index in
                        let breed = viewModel.breeds[index]
                        if breed.hasSubBreeds {
                            ForEach(breed.subBreeds.indices) { index in
                                Text("\(breed.name) \(breed.subBreeds[index])")
                                    .onTapGesture {
                                        loadImage(for: "\(breed.name) \(breed.subBreeds[index])")
                                    }
                            }
                        } else {
                            Text(breed.name)
                                .onTapGesture {
                                    loadImage(for: breed.name)
                                }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
        }
    }
}

extension HomeView {
    func loadImage(for breed: String) {
        viewModel.loadImage(for: breed)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(apiClient: DefaultAPIClient(environment: DefaultAppEnvironment())))
    }
}
