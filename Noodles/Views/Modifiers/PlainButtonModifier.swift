//
//  PlainButtonModifier.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func plainButton(action: @escaping @MainActor () -> Void) -> some View {
        self.modifier(PlainButtonModifier(action: action))
    }
}

struct PlainButtonModifier: ViewModifier {
    let action: @MainActor () -> Void
    
    func body(content: Content) -> some View {
        Button(action: action, label: { content })
            .buttonStyle(.plain)
    }
}

#Preview {
    Text("Hello, world!")
        .plainButton {
            print("Bzzt")
        }
}
