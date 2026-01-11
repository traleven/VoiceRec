//
//  PhraseTextFragment.swift
//  Noodles
//
//  Created by Ivan on 24/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

public struct PhraseTextbar<S: StringProtocol>: View {
    public let style: Style

    public var prompt: S
    @Binding public var text: String

    @State var language: String
    @State var transcript: String
    
    public init(style: Style, prompt: S, text: Binding<String>, language: String, transcript: String) {
        self.style = style
        self.prompt = prompt
        self._text = text
        self.language = language
        self.transcript = transcript
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(language)
                .font(style.font.body.emoji)
                .multilineTextAlignment(.center)
                .frame(height: 32, alignment: .center)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
            
            TextField(prompt, text: $text, prompt: Text(prompt)
                .foregroundStyle(style.color.text.placeholder.light), axis: .vertical
            )
            .labelsHidden()
            .font(style.font.body.bodyXL)
            .foregroundColor(style.color.text.regular.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if !transcript.isEmpty {
                Text(transcript)
                    .font(style.font.body.bodySmall)
                    .foregroundColor(style.color.text.regular.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)
            }
        }
    }
}

#Preview {
    PhraseTextbar(
        style: .standard,
        prompt: "Type phrase",
        text: .constant("Hi, do you have majiang mian?"),
        language: "🇬🇧",
        transcript: "Romanization text"
    )
    
    PhraseTextbar(
        style: .standard,
        prompt: "Type phrase",
        text: .constant(""),
        language: "🇬🇧",
        transcript: "Romanization text"
    )
    
    PhraseTextbar(
        style: .standard,
        prompt: "Type phrase",
        text: .constant(""),
        language: "🇬🇧",
        transcript: ""
    )
}
