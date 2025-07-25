//
//  PhraseMainFragment.swift
//  Noodles
//
//  Created by Ivan on 24/07/2025.
//

import SwiftUI

struct PhraseMainFragment: View {
    @Environment(\.style) private var style
    
    var language: String
    @Binding var text: String
    var transcript: String

    var content: [CGFloat]?
    var duration: Duration?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                PhraseTextbar(
                    prompt: "Type phrase",
                    language: language,
                    text: $text,
                    transcript: transcript
                )
                
                PhraseAudiobar(
                    content: content,
                    duration: duration
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .padding(0)
        .frame(width: 393, alignment: .topLeading)
    }
}

#Preview {
    PhraseMainFragment(
        language: "🇬🇧",
        text: .constant(""),
        transcript: ""
    )
    Divider()
    PhraseMainFragment(
        language: "🇬🇧",
        text: .constant("Hi, do you have majiang mian?"),
        transcript: "Romanization text"
    )
    Divider()
    PhraseMainFragment(
        language: "🇬🇧",
        text: .constant("Hi, do you have majiang mian?"),
        transcript: "Romanization text",
        content: Audiowaves.placeholder,
        duration: .minutes(2).add(seconds: 15)
    )
}
