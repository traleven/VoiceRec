//
//  PhraseSectionSublist.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

public struct ListSectionMetadata: View {
    public let style: Style
    
    public var options: [(String, ListItem<String>.Content)]
    
    public init(style: Style, options: [(String, ListItem<String>.Content)]) {
        self.style = style
        self.options = options
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .center, spacing: 0) {
                ForEach(options, id: \.0) { option in
                    ListItem(style: style, title: option.0, mode: .recessed, content: option.1)
                }
            }
            //HSeparator()
        }
        .padding(.top, 12)
    }
}

#Preview {
    ListSectionMetadata(
        style: .standard,
        options: [
            ("Option 1", .check(.constant(false))),
            ("Option 2", .check(.constant(true))),
            ("Option 3", .check(.constant(false))),
            ("Option 4", .check(.constant(true))),
            ("Option 5", .pill("Tag")),
            ("Option 6", .label("Non-interactive")),
        ]
    )
}
