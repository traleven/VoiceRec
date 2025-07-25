//
//  PhraseTextFragment.swift
//  Noodles
//
//  Created by Ivan on 24/07/2025.
//

import SwiftUI

struct PhraseTextbar<S: StringProtocol>: View {
    @Environment(\.style) private var style
    
    var prompt: S
    @State var language: String
    @Binding var text: String
    @State var transcript: String

    var body: some View {
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
        prompt: "Type phrase",
        language: "🇬🇧",
        text: .constant("Hi, do you have majiang mian?"),
        transcript: "Romanization text"
    )
    
    PhraseTextbar(
        prompt: "Type phrase",
        language: "🇬🇧",
        text: .constant(""),
        transcript: "Romanization text"
    )
    
    PhraseTextbar(
        prompt: "Type phrase",
        language: "🇬🇧",
        text: .constant(""),
        transcript: ""
    )
}
