//
//  AppEnvironment.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import Foundation


protocol AppEnvironment: AnyObject {
    var apiBaseUrl: URL { get }
}

// MARK: -
/// The default implementation of `AppEnvironment`.
/// Should be stored with cocoapods-keys.
final class DefaultAppEnvironment: AppEnvironment {
    var apiBaseUrl: URL {
        URL(string: "https://dog.ceo")!
    }
}
