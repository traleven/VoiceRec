//
//  PlainList.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

public struct PlainList<Content: View>: View {
    public let style: Style
    
    public var spacing: CGFloat = 0
    
    @ViewBuilder public var content: () -> Content
    
    public init(style: Style, spacing: CGFloat = 0, @ViewBuilder content: @escaping () -> Content) {
        self.style = style
        self.spacing = spacing
        self.content = content
    }
    
    public var body: some View {
        List {
            content()
                .listRowSeparator(.hidden)
                .listRowBackground(style.palette.transparent)
                .listRowInsets(.init())
                .listRowSpacing(spacing)
                .buttonStyle(.plain)
        }
        .listStyle(.plain)
        .environment(\.defaultMinListRowHeight, 0)
    }
}

#Preview {
    PlainList(style: .standard) {
        Text("A")
        Text("B")
        Text("C")
    }
}
