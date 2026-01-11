//
//  Person.swift
//  Noodles
//
//  Created by Ivan on 28/07/2025.
//

import Foundation
import SwiftData

@Model
public final class Person {
    
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
}
