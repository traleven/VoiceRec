//
//  PhraseDetailsPage.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI

struct PhraseDetailsPage: View {
    @Environment(\.style) private var style
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                Group {
                    PhraseMainFragment(language: "E", text: .constant(""), transcript: "")
                    
                    HSeparator()
                    
                    PhraseMainFragment(language: "C", text: .constant(""), transcript: "")
                    
                    Spacer(minLength: 8)
                    
                    ListSectionTextInput(title: "Notes", prompt: "Type here", text: .constant(""))
                    
                    ListSectionMultiselect(title: "Tags", tags: [
                        "Tag1", "Tag2", "Tag3",
                    ])
                    
                    ListSectionMultiselect(title: "Lessons", tags: [
                        "Lesson1", "Lesson2", "Lesson3",
                    ])
                    
                    ListSectionMultiselect(title: "Grammar", tags: [
                        "Grammar pattern A", "Grammar pattern B"
                    ])
                    
                    ListSectionSublist(title: "Context", options: [
                        ("Date encountered", .pill("Select")),
                        ("Person quoted", .pill("Select")),
                        ("Location", .pill("Select")),
                        ("Format", .pill("Select")),
                        ("Honorifics", .pill("Regular")),
                    ])
                    
                    ListSectionSublist(title: "Learning status", options: [
                        ("Still learning", .check(.constant(true))),
                        ("Mastered", .check(.constant(false))),
                    ])
                    
                    Spacer(minLength: 8)

                    ListSectionMetadata(options: [
                        ("Date created", .label("Value")),
                        ("Last edited", .label("Value")),
                    ])
                }
                .background(style.color.background.light)
            }
            .background(style.color.fill.element.primary)
        }
    }
}

#Preview {
    PhraseDetailsPage()
}
