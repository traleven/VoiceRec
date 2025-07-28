//
//  ContentView.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var topLevelNavigation: NavigationPath = .init()
    @State private var currentTab: TabPage = .phrases
    
    enum TabPage : Hashable, CaseIterable {
        case phrases, lessons, player
    }

    var body: some View {
        NavigationStack(path: $topLevelNavigation) {
            Tabbar(selection: $currentTab) { selection in
                switch selection {
                case .phrases:
                    PhrasesPage()
                        .transition(.opacity)
                case .lessons:
                    LessonsPage()
                        .transition(.opacity)
                case .player:
                    PlayerPage()
                        .transition(.opacity)
                }
            }
            .environment(\.navigate, NavigateAction(push: { command in
                topLevelNavigation.append(command)
            }))
            .navigationDestination(for: EditCommand<Phrase>.self) { command in
                PhraseDetailsPage(phrase: command.content)
            }
            .navigationDestination(for: EditCommand<Lesson>.self) { command in
                LessonDetailsPage()
            }
        }
    }
}

extension ContentView.TabPage: StringRepresentable {
    var asString: some StringProtocol {
        switch self {
        case .phrases: "Phrases"
        case .lessons: "Lessons"
        case .player: "Player"
        }
    }
}

extension ContentView.TabPage: IconRepresentable {
    var asIcon: String {
        switch self {
        case .phrases: "ellipsis.bubble.fill"
        case .lessons: "book"
        case .player: "beats.headphones"
        }
    }
}

#Preview("Full") {
    ContentView()
        .modelContainer(.previewModelContainer)
}

#Preview("Empty") {
    ContentView()
        .modelContainer(.previewEmptyModelContainer)
}
