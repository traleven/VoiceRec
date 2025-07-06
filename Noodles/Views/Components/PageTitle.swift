//
//  PageTitle.swift
//  Noodles
//
//  Created by Ivan on 06/07/2025.
//

import SwiftUI

struct PageTitle<Title: StringProtocol>: View {
    @Environment(\.style) private var style
    
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
    PageTitle(title: "Phrases", emoji: "⭐️")
    PageTitle(title: "Phrases")
}
