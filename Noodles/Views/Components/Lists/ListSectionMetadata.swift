//
//  PhraseSectionSublist.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI

struct ListSectionMetadata: View {
    var options: [(String, ListItem<String>.Content)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .center, spacing: 0) {
                ForEach(options, id: \.0) { option in
                    ListItem(title: option.0, mode: .recessed, content: option.1)
                }
            }
            //HSeparator()
        }
        .padding(.top, 12)
    }
}

#Preview {
    ListSectionMetadata(
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
