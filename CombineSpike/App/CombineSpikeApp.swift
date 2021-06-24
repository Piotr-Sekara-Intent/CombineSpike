//
//  CombineSpikeApp.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import SwiftUI

@main
struct CombineSpikeApp: App {
    private let appFoundation: AppFoundation = DefaultAppFoundation()

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel(apiClient: appFoundation.apiClient))
        }
    }
}
