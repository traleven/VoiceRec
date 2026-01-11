//
//  NoodlesApp.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import SwiftUI
import SwiftData
import NoodlesDataModel
import NoodlesDesignSystem
import NoodlesThemeStandard

@main
struct NoodlesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(.previewModelContainer)
        #warning("Switch to persistent storage eventually")
    }
}

extension EnvironmentValues {
    @Entry var style: Style = .standard
    @Entry var navigate: NavigateAction = .init(push: { _ in })
    @Entry var nativeLanguage: Language?
    @Entry var targetLanguage: Language?
}

extension ModelContainer {
    @MainActor
    private static var schema = Schema([
        AudioRecord.self,
        Language.self,
        Lesson.self,
        Person.self,
        Phrase.self,
    ])
    
    @MainActor
    static var sharedModelContainer: ModelContainer = {
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @MainActor
    static var previewModelContainer: ModelContainer = {
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            container.mainContext.populateWithDefaultData()
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @MainActor
    static var previewEmptyModelContainer: ModelContainer = {
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}

final class Preview {
    @MainActor static var language = PreviewLanguageSet()
    @MainActor static var phrase = PreviewPhraseSet()
    
    struct PreviewLanguageSet {
        var en = Language(id: "en", title: "English", icon: "🇬🇧")
        var zh = Language(id: "zh", title: "Chinese", icon: "🇨🇳")
    }
    struct PreviewPhraseSet {
        
    }
}

extension ModelContext {
    @MainActor
    func populateWithDefaultData() {
        self.insert(Preview.language.en)
        self.insert(Preview.language.zh)
        
        self.insert(Phrase(entries: [
            Phrase.Entry(language: Preview.language.en, title: "Did they reach the fundraising goal?")
        ]))
        self.insert(Phrase(entries: [
            Phrase.Entry(language: Preview.language.en, title: "Rotary hammer drill")
        ]))
        self.insert(Phrase(entries: [
            Phrase.Entry(language: Preview.language.en, title: "You're putting me in a bit of a tricky position")
        ]))
        
        self.insert(Lesson(title: "LessonA"))
        self.insert(Lesson(title: "LessonB"))
        self.insert(Lesson(title: "LessonC"))
    }
}
