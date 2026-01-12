//
//  Sortbar.swift
//  Noodles
//
//  Created by Ivan on 03/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

public struct Sortbar: View {
    public let style: Style

    public var title: String
    public var direction: SortOrder = .forward
    
    public init(style: Style, title: String, direction: SortOrder = .forward) {
        self.style = style
        self.title = title
        self.direction = direction
    }

    public var body: some View {
        HStack(alignment: .center) {
            HStack(alignment: .center, spacing: 8) {
                SortPill(style: style, title: title, direction: direction)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
                        
            HStack(alignment: .center, spacing: 8) {
                // Display mode toggle
                Image(systemName: "line.3.horizontal")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .hidden()
            }
        }
        .padding([.leading, .top], 8)
        .padding(.trailing, 16)
        .padding(.bottom, 4)
        .frame(width: 393, alignment: .center)
    }
}

struct SortPill: View {
    let style: Style
    
    var title: String
    var direction: SortOrder = .forward

    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            Text(title)
                .font(style.font.body.labelSmall)
                .multilineTextAlignment(.center)
                .foregroundStyle(style.color.text.button.secondary)
            
            Image(systemName: direction == .forward ? "arrow.down" : "arrow.up")
                .resizable()
                .frame(width: 10, height: 10)
                .foregroundStyle(style.color.text.button.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .cornerRadius(8)
    }
}

#Preview {
    Sortbar(style: .standard, title: "Recent", direction: .forward)
    Divider()
    Sortbar(style: .standard, title: "Recent", direction: .reverse)
    Divider()
    Sortbar(style: .standard, title: "A-Z")
}
