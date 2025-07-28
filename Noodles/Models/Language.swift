//
//  Language.swift
//  Noodles
//
//  Created by Ivan on 28/07/2025.
//

import Foundation
import SwiftData

@Model
final class Language : Identifiable {
    var id: ID
    var title: String
    var icon: String
    
    init(id: ID, title: String, icon: String) {
        self.id = id
        self.title = title
        self.icon = icon
    }
}

extension Language {
    struct ID : Codable, Hashable, Identifiable, Equatable, Sendable, ExpressibleByStringLiteral {        
        var id: String
        
        init(id: String) {
            self.id = id
        }
        
        init(stringLiteral value: String) {
            id = value
        }
    }
}
