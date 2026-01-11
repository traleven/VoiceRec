//
//  PageTitle.swift
//  Noodles
//
//  Created by Ivan on 06/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

struct PageTitle<Title: StringProtocol>: View {
    let style: Style
    
    var title: Title
    var emoji: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(emoji)
                .multilineTextAlignment(.trailing)

            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(style.font.heading.displayTitle)
        .foregroundColor(style.color.text.regular.primary)
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 12)
    }
}

#Preview {
    PageTitle(style: .standard, title: "Phrases", emoji: "⭐️")
    PageTitle(style: .standard, title: "Phrases")
}
