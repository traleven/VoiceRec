//
//  Phrase.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import Foundation
import SwiftData

enum LearningStatus : Hashable, Codable, Sendable {
    case learning, mastered
}

extension Phrase {
    @Model
    final class Entry : ObservableObject {
        @Relationship(deleteRule: .noAction)
        var language: Language
        var title: String
        var subtitle: String
        
        @Relationship(deleteRule: .cascade)
        var audio: AudioRecord?
        var notes: String
        
        init(language: Language, title: String = "", subtitle: String = "", audio: AudioRecord? = nil, notes: String = "") {
            self.language = language
            self.title = title
            self.subtitle = subtitle
            self.audio = audio
            self.notes = notes
        }
    }
}

@Model
final class Phrase {
    @Relationship(deleteRule: .cascade)
    private var entries: [Entry] = []
    
    @Transient private var cache: [Language : Entry] = [:]
    func entry(for language: Language) -> Entry {
        if let entry = cache[language] { return entry }
        if let entry = entries.first(where: { $0.language == language }) {
            cache[language] = entry
            return entry
        }
        let entry = Entry(language: language)
        entries.append(entry)
        cache[language] = entry
        return entry
    }
    
    var tags: [String]
    
    @Relationship(deleteRule: .nullify, inverse: \Lesson.phrases)
    var lessons: [Lesson]
    
    var grammar: [String]
    
    var dateEncountered: Date?
    
    @Relationship(deleteRule: .nullify)
    var personQuoted: Person?
    var location: String
    var format: String
    var honorifics: String
    
    var learningStatus: LearningStatus
    
    var created: Date
    var modified: Date?
    
    init(
        entries: [Entry] = [],
        tags: [String] = [],
        lessons: [Lesson] = [],
        grammar: [String] = [],
        dateEncountered: Date? = nil,
        personQuoted: Person? = nil,
        location: String = "",
        format: String = "",
        honorifics: String = "",
        learningStatus: LearningStatus = .learning,
        created: Date = .now,
        modified: Date? = nil
    ) {
        self.entries = entries
        self.tags = tags
        self.lessons = lessons
        self.grammar = grammar
        self.dateEncountered = dateEncountered
        self.personQuoted = personQuoted
        self.location = location
        self.format = format
        self.honorifics = honorifics
        self.learningStatus = learningStatus
        self.created = created
        self.modified = modified
    }
}
