//
//  TagsSection.swift
//  Noodles
//
//  Created by Ivan on 07/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

struct TagsSection: View {
    let style: Style
    
    var items: [String]
    var search: Visibility = .visible
    
    @State private var searchText: String = ""
    
    private var filteredItems: [String] {
        searchText.isEmpty ? items : items.filter({ $0.lowercased().contains(searchText.lowercased()) })
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if search != .hidden {
                ListItem(style: style, title: "Search", content: .search($searchText))
            }
            
            TagList(style: style, items: filteredItems)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    TagsSection(style: .standard, items: ["Tag1", "Tag2", "Tag3"])
    TagsSection(style: .standard, items: ["Tag1", "Tag2", "Tag3"], search: .hidden)
}
