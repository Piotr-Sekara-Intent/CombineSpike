//
//  ApiError.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import Foundation

struct ApiError: Error, HumanReadableError {

    // MARK: Types
    
    enum Reason {
        case connectionFailed
        case authorizationFailed
        case invalidRequest
        case invalidResponse
        case unknown
    }

    init(reason: Reason, _ underlying: Error? = nil) {
        self.reason = reason
        self.underlying = underlying
    }

    init(_ underlying: Error) {
        switch underlying {
        case is ApiError:
            self = underlying as! ApiError
        case is URLError:
            self.init(reason: .connectionFailed, underlying)
        case is EncodingError:
            self.init(reason: .invalidRequest, underlying)
        case is DecodingError:
            self.init(reason: .invalidResponse, underlying)
        default:
            self.init(reason: .unknown, underlying)
        }
    }

    // MARK: Properties

    let reason: Reason

    let underlying: Error?

    // MARK: HumanReadableError
    /// - SeeAlso: HumanReadableError.humanReadableDescription
    var humanReadableDescription: String {
        switch reason {
        case .connectionFailed:
            return "Looks like connection failed. Please try again."
        case .invalidResponse:
            return "Response was invalid."
        default:
            return "Something went wrong. Please try again."
        }
    }
}
