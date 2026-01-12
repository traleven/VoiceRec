//
//  PhrasesPage.swift
//  Noodles
//
//  Created by Ivan on 04/07/2025.
//

import SwiftUI
import SwiftData
import NoodlesDataModel
import NoodlesUIComponents

struct PhrasesPage: View {
    @Environment(\.style) private var style
    @Environment(\.navigate) private var navigate
    @Environment(\.modelContext) private var modelContext
    @Environment(\.nativeLanguage) private var nativeLanguage
    
    @Query()
    private var phrases: [Phrase]
    
    @State var searchText: String = ""
    @State var inputText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Navbar(style: style, mode: .regular)
            
            // controls
            VStack(spacing: 0) {
                if !phrases.isEmpty {
                    PageControlsFragment(
                        searchText: $searchText,
                        mode: .standard
                    )
                }
            }

            // content
            if phrases.isEmpty {
                EmptyPageContent(
                    style: style,
                    title: "Create phrase",
                    icon: "plus.circle",
                    action: openNewPhrase
                )
            } else if let nativeLanguage {
                PlainList(style: style) {
                    ForEach(phrases.sorted(by: { $0.sortIndex > $1.sortIndex })) { phrase in
                        PhraseListItem(
                            style: style,
                            phrase: phrase,
                            for: nativeLanguage,
                            open: { withAnimation {
                                navigate(
                                    to: EditCommand(phrase)
                                )
                            }}
                        )
                    }
                }
            } else {
                ContentUnavailableView
                    .error("Somehow there is no language set in your profile")
            }
            
            // input
            Inputbar(style: style, text: $inputText, language: nativeLanguage!) { text, language in
                let newPhrase = Phrase(entries: [
                    Phrase.Entry(language: language, title: text)
                ])
                modelContext.insert(newPhrase)
                inputText = ""
            }
        }
    }
    
    private func openNewPhrase() {
        print("TODO: Create a new phrase and open it in a PhraseDetails view")
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
