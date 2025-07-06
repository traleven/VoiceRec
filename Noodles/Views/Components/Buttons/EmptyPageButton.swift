//
//  EmptyPageButton.swift
//  Noodles
//
//  Created by Ivan on 04/07/2025.
//

import SwiftUI

struct EmptyPageButton<Title: StringProtocol>: View {
    @Environment(\.style) private var style
    
    var title: Title
    var icon: String = "plus.circle"

    var body: some View {
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
    EmptyPageButton(title: "Button label")
}
