//
//  EmptyPageButton.swift
//  Noodles
//
//  Created by Ivan on 04/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

public struct EmptyPageButton<Title: StringProtocol>: View {
    let style: Style
    let title: Title
    let icon: String
    let action: () -> Void
    
    public init(style: Style, title: Title, icon: String = "plus.circle", action: @escaping () -> Void) {
        self.style = style
        self.title = title
        self.icon = icon
        self.action = action
    }

    public var body: some View {
        Button(action: action, label: {
            VStack(alignment: .center, spacing: 8) {
                Image(systemName: icon)
                    .resizable()
                    .foregroundStyle(style.color.icon.tertiary.foreground)
                    .frame(width: 64, height: 64)
                
                Text(title)
                    .multilineTextAlignment(.center)
                    .font(style.font.heading.title2)
                    .foregroundStyle(style.color.text.regular.secondary)
            }
        })
        .padding(0)
    }
}

#Preview {
    EmptyPageButton(
        style: .standard,
        title: "Button label",
        action: { print("Button pressed in preview") },
    )
}
