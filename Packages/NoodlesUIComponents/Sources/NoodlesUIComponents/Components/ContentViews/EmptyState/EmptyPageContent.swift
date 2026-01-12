//
//  EmptyPage.swift
//  Noodles
//
//  Created by Ivan on 06/07/2025.
//

import SwiftUI
import NoodlesDesignSystem

public struct EmptyPageContent<Title: StringProtocol>: View {
    let style: Style
    let title: Title
    let icon: String
    let action: () -> Void
    
    public init(
        style: Style,
        title: Title,
        icon: String = "plus.circle",
        action: @escaping () -> Void
    ) {
        self.style = style
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            EmptyPageButton(
                style: style,
                title: title,
                icon: icon,
                action: action,
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    EmptyPageContent(
        style: .standard,
        title: "Button label",
        action: { print("Button pressed in preview") },
    )
}
