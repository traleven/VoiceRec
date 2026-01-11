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
    public let style: Style

    public var title: Title
    public var icon: String = "plus.circle"
    
    public init(style: Style, title: Title, icon: String = "plus.circle") {
        self.style = style
        self.title = title
        self.icon = icon
    }

    public var body: some View {
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
        .padding(0)
    }
}

#Preview {
    EmptyPageButton(style: .standard, title: "Button label")
}
