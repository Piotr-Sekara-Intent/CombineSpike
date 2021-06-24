//
//  ViewState.swift
//  CombineSpike
//
//  Created by Piotr on 23/06/2021.
//

import Foundation

enum ViewState {
    case loading
    case loaded
    case failure(Error)
}
