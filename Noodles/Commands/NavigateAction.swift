//
//  NavigationAction.swift
//  Noodles
//
//  Created by Ivan on 27/07/2025.
//

import SwiftUI

@MainActor
struct NavigateAction {
    let push: @MainActor (any Hashable) -> Void
    
    @MainActor func callAsFunction(to command: any Hashable) {
        push(command)
    }
}
