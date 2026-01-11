//
//  PhraseMainFragment.swift
//  Noodles
//
//  Created by Ivan on 24/07/2025.
//

import SwiftUI
import SwiftData
import NoodlesDataModel
import NoodlesUIComponents

struct PhraseMainFragment: View {
    @Environment(\.style) private var style
    
    @ObservedObject var entry: Phrase.Entry

    var content: [CGFloat]?
    var duration: Duration?
    
    init(entry: Phrase.Entry, content: [CGFloat]? = nil, duration: Duration? = nil) {
        self.entry = entry
        self.content = content
        self.duration = duration
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                PhraseTextbar(
                    style: style,
                    prompt: "Type phrase",
                    text: $entry.title,
                    language: entry.language.icon,
                    transcript: entry.subtitle
                )
                
                PhraseAudiobar(
                    style: style,
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
    Group {
        PhraseMainFragment(
            entry: Phrase.Entry(language: Preview.language.en, title: "")
        )
        Divider()
        PhraseMainFragment(
            entry: Phrase.Entry(
                language: Preview.language.en,
                title: "Hi, do you have majiang mian?",
                subtitle: "Romanization text"
            )
        )
        Divider()
        PhraseMainFragment(
            entry: Phrase.Entry(
                language: Preview.language.en,
                title: "Hi, do you have majiang mian?",
                subtitle: "Romanization text"
            ),
            content: Audiowaves.placeholder,
            duration: .minutes(2).add(seconds: 15)
        )
    }
    .modelContainer(.previewModelContainer)
}
