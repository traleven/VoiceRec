//
//  PhraseSectionHeading.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

public struct PhraseSectionHeading<Title: StringProtocol, Content: View>: View {
    public let style: Style

    public var title: Title
    @ViewBuilder public let content: () -> Content
    
    @State private var expanded: Bool = true
    
    var icon: String {
        expanded ? "chevron.up" : "chevron.down"
    }
    
    public init(style: Style, title: Title, content: @escaping () -> Content) {
        self.style = style
        self.title = title
        self.content = content
        self.expanded = expanded
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center, spacing: 12) {
                    Text(title)
                        .font(style.font.heading.title4)
                        .foregroundColor(style.color.text.regular.secondary)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    Image(systemName: icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10, height: 10)
                        .foregroundStyle(style.color.icon.tertiary.foreground)
                        .plainButton(withAnimation: {
                            expanded.toggle()
                        })
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if expanded {
                    content()
                        .transition(.opacity)
                }
            }
            HSeparator(style: style)
        }
        .padding(.top, 12)
    }
}

#Preview {
    PhraseSectionHeading(style: .standard, title: "Section heading") {
        Text("Content here")
    }
}
