//
//  Lesson.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import Foundation
import SwiftData

@Model
final class Lesson {
    var title: String = ""
    var phrases: [Phrase] = []
    
    init(title: String = "") {
        self.title = title
    }
}
