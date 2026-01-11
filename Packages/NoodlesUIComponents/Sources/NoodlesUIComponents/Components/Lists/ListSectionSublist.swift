//
//  PhraseSectionSublist.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

public struct ListSectionSublist<Title: StringProtocol>: View {
    public let style: Style
    
    public var title: Title
    public var options: [(String, ListItem<String>.Content)]
    
    public init(style: Style, title: Title, options: [(String, ListItem<String>.Content)]) {
        self.style = style
        self.title = title
        self.options = options
    }
    
    public var body: some View {
        PhraseSectionHeading(style: style, title: title) {
            ForEach(options, id: \.0) { option in
                ListItem(style: style, title: option.0, content: option.1)
            }
        }
    }
}

#Preview {
    ListSectionSublist(
        style: .standard,
        title: "Section heading",
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
