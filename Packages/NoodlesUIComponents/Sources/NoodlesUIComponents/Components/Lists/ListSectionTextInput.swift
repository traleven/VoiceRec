//
//  PhraseSectionTextInput.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

public struct ListSectionTextInput<Title: StringProtocol, Prompt: StringProtocol>: View {
    public let style: Style
    
    public var title: Title
    public var prompt: Prompt
    
    @Binding public var text: String
    
    public init(style: Style, title: Title, prompt: Prompt, text: Binding<String>) {
        self.style = style
        self.title = title
        self.prompt = prompt
        self._text = text
    }
    
    public var body: some View {
        PhraseSectionHeading(style: style, title: title) {
            TextInput(style: style, prompt: prompt, text: $text)
        }
    }
}

#Preview {
    ListSectionTextInput(
        style: .standard,
        title: "Section heading",
        prompt: "Type here",
        text: .constant("")
    )
    ListSectionTextInput(
        style: .standard,
        title: "Section heading",
        prompt: "Type here",
        text: .constant("Something typed")
    )
}
