//
//  Language.swift
//  Noodles
//
//  Created by Ivan on 28/07/2025.
//

import Foundation
import SwiftData

@Model
public final class Language : Identifiable {
    public var id: ID
    public var title: String
    public var icon: String
    
    public init(id: ID, title: String, icon: String) {
        self.id = id
        self.title = title
        self.icon = icon
    }
}

extension Language {
    public struct ID : Codable, Hashable, Identifiable, Equatable, Sendable, ExpressibleByStringLiteral {
        public var id: String
        
        public init(id: String) {
            self.id = id
        }
        
        public init(stringLiteral value: String) {
            id = value
        }
    }
}
