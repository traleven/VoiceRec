//
//  TagList.swift
//  Noodles
//
//  Created by Ivan on 07/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

struct TagList: View {
    let style: Style
    
    var items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(items, id: \.self) { item in
                        PillButton(style: style, action: {}, label: item, role: .regular)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 16)
    }
}

#Preview {
    TagList(style: .standard, items: ["Tag1", "Tag2", "Tag3", "Tag4", "Tag5"])
}
