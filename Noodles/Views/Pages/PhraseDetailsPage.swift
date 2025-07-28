//
//  PhraseDetailsPage.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI

struct PhraseDetailsPage: View {
    @Environment(\.style) private var style
    @Environment(\.nativeLanguage) private var nativeLanguage
    @Environment(\.targetLanguage) private var targetLanguage
    
    var phrase: Phrase
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                Group {
                    if let nativeLanguage {
                        PhraseMainFragment(entry: phrase.entry(for: nativeLanguage))
                    } else {
                        ContentUnavailableView.error("Somehow your native language is not set on your profile")
                    }
                    
                    HSeparator()
                    
                    if let targetLanguage {
                        PhraseMainFragment(entry: phrase.entry(for: targetLanguage))
                    } else {
                        ContentUnavailableView.error("Somehow your target language is not set on your profile")
                    }

                    Spacer(minLength: 8)
                    
                    if let targetLanguage {
                        @Bindable var entry = phrase.entry(for: targetLanguage)
                        ListSectionTextInput(title: "Notes", prompt: "Type here", text: $entry.notes)
                    } else {
                        PhraseSectionHeading(title: "Notes") {
                            ContentUnavailableView.error("Somehow your target language is not set on your profile")
                        }
                    }
                    
                    ListSectionMultiselect(title: "Tags", tags: phrase.tags)
                    
                    ListSectionMultiselect(title: "Lessons", tags: phrase.lessons.map { $0.title })
                    
                    ListSectionMultiselect(title: "Grammar", tags: phrase.grammar)
                    
                    ListSectionSublist(title: "Context", options: [
                        ("Date encountered", .pill(phrase.dateEncountered?.formatted() ?? "Select")),
                        ("Person quoted", .pill(phrase.personQuoted?.name ?? "Select")),
                        ("Location", .pill(phrase.location.isEmpty ? "Select" : phrase.location)),
                        ("Format", .pill(phrase.format.isEmpty ? "Select" : phrase.format)),
                        ("Honorifics", .pill(phrase.honorifics.isEmpty ? "Regular" : phrase.honorifics)),
                    ])
                    
                    ListSectionSublist(title: "Learning status", options: [
                        ("Still learning", .check(bindLearningStatus(phrase, value: .learning))),
                        ("Mastered", .check(bindLearningStatus(phrase, value: .mastered))),
                    ])
                    
                    Spacer(minLength: 8)

                    ListSectionMetadata(options: [
                        ("Date created", .label(phrase.created.formatted())),
                        ("Last edited", .label((phrase.modified ?? phrase.created).formatted())),
                    ])
                }
                .background(style.color.background.light)
            }
            .background(style.color.fill.element.primary)
        }
    }
    
    private func bindLearningStatus(_ phrase: Phrase, value: LearningStatus) -> Binding<Bool> {
        .init(get: {
            phrase.learningStatus == value
        }, set: {
            if $0 {
                phrase.learningStatus = value
            }
        })
    }
}

#Preview {
    NavigationStack {
        PhraseDetailsPage(phrase: Phrase(entries: [
            Phrase.Entry(language: Preview.language.en, title: "Hi, do you have majiang mian?"),
            Phrase.Entry(language: Preview.language.zh, notes: "Majiang mian is a type of noodle dish")
        ], tags: [
            "Tag1", "Tag2", "Bzzt",
        ], grammar: [
            "Grammar pattern A", "Grammar pattern B",
        ]))
    }
    .modelContainer(.previewModelContainer)
    .environment(\.nativeLanguage, Preview.language.en)
    .environment(\.targetLanguage, Preview.language.zh)
}
