//
//  PhraseSectionSublist.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI

struct ListSectionSublist<Title: StringProtocol>: View {
    var title: Title
    var options: [(String, ListItem<String>.Content)]
    
    var body: some View {
        PhraseSectionHeading(title: title) {
            ForEach(options, id: \.0) { option in
                ListItem(title: option.0, content: option.1)
            }
        }
    }
}

#Preview {
    ListSectionSublist(
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
