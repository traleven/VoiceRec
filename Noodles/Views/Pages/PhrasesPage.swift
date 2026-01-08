//
//  PhrasesPage.swift
//  Noodles
//
//  Created by Ivan on 04/07/2025.
//

import SwiftUI
import SwiftData

struct PhrasesPage: View {
    @Environment(\.navigate) private var navigate
    @Environment(\.modelContext) private var modelContext
    @Environment(\.nativeLanguage) private var nativeLanguage
    
    @Query()
    private var phrases: [Phrase]
    
    @State var searchText: String = ""
    @State var inputText: String = ""
    
    var body: some View {
        PageLayout(toolbar: {
            Navbar(mode: .regular)
        }, controls: {
            if !phrases.isEmpty {
                PageControlsFragment(searchText: $searchText, mode: .standard)
            }
        }, content: {
            if phrases.isEmpty {
                EmptyPage(title: "Create phrase", icon: "plus.circle")
            } else {
                if let nativeLanguage {
                    PlainList {
                        ForEach(phrases.sorted(by: { $0.sortIndex > $1.sortIndex })) { phrase in
                            PhraseListItem(phrase, for: nativeLanguage)
                                .plainButton(withAnimation: {
                                    navigate(to: EditCommand(phrase))
                                })
                        }
                    }
                } else {
                    ContentUnavailableView
                        .error("Somehow there is no language set in your profile")
                }
            }
        }, input: {
            Inputbar(text: $inputText, language: nativeLanguage!) { text, language in
                let newPhrase = Phrase(entries: [
                    Phrase.Entry(language: language, title: text)
                ])
                modelContext.insert(newPhrase)
                inputText = ""
            }
        })
    }
}

#Preview("Full") {
    NavigationStack {
        PhrasesPage()
    }
    .modelContainer(.previewModelContainer)
    .environment(\.nativeLanguage, Preview.language.en)
}

#Preview("Empty") {
    NavigationStack {
        PhrasesPage()
    }
    .modelContainer(.previewEmptyModelContainer)
    .environment(\.nativeLanguage, Preview.language.en)
}
