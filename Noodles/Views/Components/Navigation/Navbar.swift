//
//  Navbar.swift
//  Noodles
//
//  Created by Ivan on 03/07/2025.
//

import SwiftUI

struct Navbar: ToolbarContent {
    
    var mode: Mode = .regular
    
    @ToolbarContentBuilder
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            if mode == .lesson || mode == .phrase || mode == .other {
                Button(action: {}, label: { Image(systemName: "chevron.left") })
            }
            if mode == .regular || mode == .legacy {
                Button(action: {}, label: { Image(systemName: "person.circle") })
            }
        }
        ToolbarItemGroup(placement: .principal) {
            if mode == .regular {
                Text("Title")
            }
            if mode == .legacy {
                TextField("Title", text: .constant("Bzzt"), prompt: Text("Prompt"), axis: .horizontal)
                    .textFieldStyle(.roundedBorder)
            }
        }
        ToolbarItemGroup(placement: .topBarTrailing) {
            if mode == .lesson || mode == .phrase {
                Button(action: {}, label: { Image(systemName: "heart") })
            }
            if mode == .lesson || mode == .phrase {
                Button(action: {}, label: { Image(systemName: "paperplane") })
            }
            if mode == .regular || mode == .lesson || mode == .legacy {
                Button(action: {}, label: { Image(systemName: "flag") })
            }
            if mode == .regular {
                Button(action: {}, label: { Image(systemName: "magnifyingglass") })
            }
            if mode == .regular {
                Button(action: {}, label: { Image(systemName: "plus") })
            }
            if mode == .lesson || mode == .phrase || mode == .other {
                Button(action: {}, label: { Image(systemName: "ellipsis") })
            }
        }
    }
}

extension Navbar {
    enum Mode {
        case regular, lesson, phrase, other, legacy
    }
}

#Preview {
    NavigationStack {
        Text("Default")
        .toolbar(content: {
            Navbar(mode: .regular)
        })
    }
    NavigationStack {
        Text("Lesson")
        .toolbar(content: {
            Navbar(mode: .lesson)
        })
    }
    NavigationStack {
        Text("Phrase")
        .toolbar(content: {
            Navbar(mode: .phrase)
        })
    }
    NavigationStack {
        Text("Other")
        .toolbar(content: {
            Navbar(mode: .other)
        })
    }
    NavigationStack {
        Text("Legacy")
        .toolbar(content: {
            Navbar(mode: .legacy)
        })
    }
}
