//
//  PhraseSectionMultiselect.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI

struct PhraseSectionMultiselect<Title: StringProtocol>: View {
    var title: Title
    var tags: [String]
            
    var body: some View {
        PhraseSectionHeading(title: title) {
            TagsSection(items: tags, search: .visible)
        }
    }
}

#Preview {
    PhraseSectionMultiselect(
        title: "Section heading",
        tags: [ "Tag1", "Tag2", "AnotherTag", "Some other tag" ]
    )
}
