//
//  PhraseSectionHeading.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI

struct PhraseSectionHeading<Title: StringProtocol, Content: View>: View {
    @Environment(\.style) private var style
    
    var title: Title
    @ViewBuilder let content: () -> Content
    
    @State private var expanded: Bool = true
    
    var icon: String {
        expanded ? "chevron.up" : "chevron.down"
    }
    
    var body: some View {
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
            HSeparator()
        }
        .padding(.top, 12)
    }
}

#Preview {
    PhraseSectionHeading(title: "Section heading") {
        Text("Content here")
    }
}
