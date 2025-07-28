//
//  Person.swift
//  Noodles
//
//  Created by Ivan on 28/07/2025.
//

import Foundation
import SwiftData

@Model
final class Person {
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
