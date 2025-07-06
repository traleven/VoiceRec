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
    
    enum TabPage : Hashable {
        case phrases, lessons, player
    }

    var body: some View {
        NavigationStack(path: $topLevelNavigation) {
            Tabbar(selection: $currentTab) {
                Tab(value: .phrases) {
                    PhrasesPage()
                } label: { TabbarItem(title: "Phrases", icon: "ellipsis.bubble.fill") }
                Tab(value: .lessons) {
                    LessonsPage()
                } label: { TabbarItem(title: "Lessons", icon: "book") }
//                Tab(value: .player) {
//                    PlayerPage()
//                } label: { TabbarItem(title: "Player", icon: "beats.headphones") }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
