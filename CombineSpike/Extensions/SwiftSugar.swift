//
//  SwiftSugar.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import Foundation

@inlinable func with<T>(_ subject: T, _ transform: (_ subject: inout T) throws -> Void) rethrows -> T {
    var subject = subject
    try transform(&subject)
    return subject
}
