//
//  PhrasesPage.swift
//  Noodles
//
//  Created by Ivan on 04/07/2025.
//

import SwiftUI
import SwiftData

struct PhrasesPage: View {
    @Environment(\.navigate) var navigate
    @Environment(\.nativeLanguage) var nativeLanguage
    @Query private var phrases: [Phrase]
    
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
                        ForEach(phrases) { phrase in
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
            Inputbar(text: $inputText)
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
