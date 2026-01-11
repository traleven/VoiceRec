//
//  CardItem.swift
//  Noodles
//
//  Created by Ivan on 07/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

struct CardItem<Title: StringProtocol>: View {
    let style: Style

    enum Layout { case horizontal, vertical }
    
    var title: Title
    var icon: String
    var direction: Layout
    
    var body: some View {
        XLayout(direction: direction, spacing: 12) {
            VStack(alignment: .center, spacing: 8) {
                Text(icon)
                    .font(direction == .horizontal ? style.font.heading.title1 : style.font.body.emojiXL)
                    .multilineTextAlignment(.center)
                    .foregroundColor(style.color.text.regular.primary)
            }
            .frame(minWidth: direction == .horizontal ? 60 : 172.5, minHeight: direction == .horizontal ? 60 : 172.5, alignment: .center)
            .background(style.color.fill.element.primary)
            .cornerRadius(direction == .horizontal ? 8 : 16)
            
            HStack(alignment: .center, spacing: 8) {
                Text(title)
                    .font(style.font.body.label)
                    .foregroundColor(style.color.text.regular.primary)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(0)
        }
    }

    struct XLayout<Content: View>: View {
        var direction: Layout
        var spacing: CGFloat?
        
        @ViewBuilder var content: () -> Content
        
        var body: some View {
            switch direction {
            case .horizontal:
                HStack(alignment: .center, spacing: spacing, content: content)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            case .vertical:
                VStack(alignment: .center, spacing: spacing, content: content)
                    .frame(maxWidth: 172.5, alignment: .top)
            }
        }
    }
}


#Preview {
    CardItem(style: .standard, title: "Ordering majiang mian next door", icon: "🍜", direction: .horizontal)
    Divider()
    CardItem(style: .standard, title: "Ordering majiang mian next door", icon: "🍜", direction: .vertical)
}
