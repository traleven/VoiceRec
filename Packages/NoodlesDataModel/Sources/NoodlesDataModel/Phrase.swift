//
//  Phrase.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import Foundation
import SwiftData

public enum LearningStatus : Hashable, Codable, Sendable {
    case learning, mastered
}

extension Phrase {
    @Model
    public final class Entry : ObservableObject {
        @Relationship(deleteRule: .noAction)
        public var language: Language
        public var title: String
        public var subtitle: String
        
        @Relationship(deleteRule: .cascade)
        public var audio: AudioRecord?
        public var notes: String
        
        public init(language: Language, title: String = "", subtitle: String = "", audio: AudioRecord? = nil, notes: String = "") {
            self.language = language
            self.title = title
            self.subtitle = subtitle
            self.audio = audio
            self.notes = notes
        }
    }
}

@Model
public final class Phrase {
    @Relationship(deleteRule: .cascade)
    private var entries: [Entry] = []
    
    @Transient private var cache: [Language : Entry] = [:]
    public func entry(for language: Language) -> Entry {
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
    
    public var tags: [String]
    
    @Relationship(deleteRule: .nullify, inverse: \Lesson.phrases)
    public var lessons: [Lesson]
    
    public var grammar: [String]
    
    public var dateEncountered: Date?
    
    @Relationship(deleteRule: .nullify)
    public var personQuoted: Person?
    public var location: String
    public var format: String
    public var honorifics: String
    
    public var learningStatus: LearningStatus
    
    public var created: Date
    public var modified: Date?
    public var sortIndex: Date { modified ?? created }
    
    public init(
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
