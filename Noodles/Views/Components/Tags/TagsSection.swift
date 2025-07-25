//
//  TagsSection.swift
//  Noodles
//
//  Created by Ivan on 07/07/2025.
//

import SwiftUI

struct TagsSection: View {
    var items: [String]
    var search: Visibility = .visible
    
    @State private var searchText: String = ""
    
    private var filteredItems: [String] {
        searchText.isEmpty ? items : items.filter({ $0.lowercased().contains(searchText.lowercased()) })
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if search != .hidden {
                ListItem(title: "Search", content: .search($searchText))
            }
            
            TagList(items: filteredItems)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    TagsSection(items: ["Tag1", "Tag2", "Tag3"])
    TagsSection(items: ["Tag1", "Tag2", "Tag3"], search: .hidden)
}
