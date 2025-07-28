//
//  EditCommand.swift
//  Noodles
//
//  Created by Ivan on 27/07/2025.
//

import Foundation

struct EditCommand<Content: Hashable>: Hashable {
    let content: Content
    
    init(_ content: Content) {
        self.content = content
    }
}
