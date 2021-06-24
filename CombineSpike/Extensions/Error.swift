//
//  Error.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import Foundation

extension Error {
    var humanReadableDescription: String {
        (self as? HumanReadableError)?.humanReadableDescription ?? localizedDescription
    }
}
