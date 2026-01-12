//
//  PhraseSectionMultiselect.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

public struct ListSectionMultiselect<Title: StringProtocol>: View {
    public let style: Style
    
    public var title: Title
    public var tags: [String]
    
    public init(style: Style, title: Title, tags: [String]) {
        self.style = style
        self.title = title
        self.tags = tags
    }
            
    public var body: some View {
        PhraseSectionHeading(style: style, title: title) {
            TagsSection(style: style, items: tags, search: .visible)
        }
    }
}

#Preview {
    ListSectionMultiselect(
        style: .standard,
        title: "Section heading",
        tags: [ "Tag1", "Tag2", "AnotherTag", "Some other tag" ]
    )
}
