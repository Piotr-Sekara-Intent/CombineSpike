//
//  MockAppEnvironment.swift
//  CombineSpikeTests
//
//  Created by Piotr on 24/06/2021.
//

import Foundation
@testable import CombineSpike

final class MockAppEnvironment: AppEnvironment {
    var apiBaseUrl: URL {
        URL(string: "https://feature.com")!
    }
}
