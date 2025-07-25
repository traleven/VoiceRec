//
//  PhraseSectionTextInput.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI

struct ListSectionTextInput<Title: StringProtocol, Prompt: StringProtocol>: View {
    var title: Title
    var prompt: Prompt
    
    @Binding var text: String
    
    var body: some View {
        PhraseSectionHeading(title: title) {
            TextInput(prompt: prompt, text: $text)
        }
    }
}

#Preview {
    ListSectionTextInput(
        title: "Section heading",
        prompt: "Type here",
        text: .constant("")
    )
    ListSectionTextInput(
        title: "Section heading",
        prompt: "Type here",
        text: .constant("Something typed")
    )
}
