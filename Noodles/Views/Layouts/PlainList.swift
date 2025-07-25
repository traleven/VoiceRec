//
//  PlainList.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI

struct PlainList<Content: View>: View {
    @Environment(\.style) private var style
    
    var spacing: CGFloat = 0
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
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
    PlainList() {
        Text("A")
        Text("B")
        Text("C")
    }
}
