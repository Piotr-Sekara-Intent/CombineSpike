//
//  AppFoundation.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import Foundation

protocol AppFoundation {

    /// The API client.
    var apiClient: APIClient { get }

    /// The environment of the running app.
    var environment: AppEnvironment { get }
}

final class DefaultAppFoundation: AppFoundation {
    private(set) lazy var apiClient: APIClient = {
        DefaultAPIClient(environment: environment)
    }()

    private(set) lazy var environment: AppEnvironment = {
        DefaultAppEnvironment()
    }()
}
