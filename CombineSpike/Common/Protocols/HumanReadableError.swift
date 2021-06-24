//
//  HumanReadableError.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import Foundation

/// Describes an error that has a human-readable reason.
protocol HumanReadableError {
    /// A localized human-readable text that describes the error.
    var humanReadableDescription: String { get }
}
