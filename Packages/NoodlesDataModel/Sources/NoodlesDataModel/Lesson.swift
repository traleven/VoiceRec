//
//  Lesson.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import Foundation
import SwiftData

@Model
public final class Lesson {
    public var title: String = ""
    public var phrases: [Phrase] = []
    
    public init(title: String = "") {
        self.title = title
    }
}
