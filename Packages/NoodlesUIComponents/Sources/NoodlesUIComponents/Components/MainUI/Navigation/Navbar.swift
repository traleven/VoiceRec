//
//  Navbar.swift
//  Noodles
//
//  Created by Ivan on 03/07/2025.
//

import SwiftUI
import NoodlesDesignSystem

public struct Navbar: View {
    private let style: Style
    
    public var mode: Mode = .regular
    
    public init(style: Style, mode: Mode) {
        self.style = style
        self.mode = mode
    }
    
    @ViewBuilder
    public var body: some View {
        HStack(spacing: 0) {
            if mode == .lesson || mode == .phrase || mode == .other {
                Button(action: {}, label: { Image(systemName: "chevron.left") })
            }
            if mode == .regular || mode == .legacy {
                Button(action: {}, label: { Image(systemName: "person.circle") })
            }

            if mode == .regular {
                Text("Title")
            }
            if mode == .legacy {
                TextField("Title", text: .constant("Bzzt"), prompt: Text("Prompt"), axis: .horizontal)
                    .textFieldStyle(.roundedBorder)
            }
            
            Spacer()

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
    public enum Mode {
        case regular, lesson, phrase, other, legacy
    }
}

#Preview {
    NavigationStack {
        Text("Default")
        .toolbar(content: {
            Navbar(style: .standard, mode: .regular)
        })
    }
    NavigationStack {
        Text("Lesson")
        .toolbar(content: {
            Navbar(style: .standard, mode: .lesson)
        })
    }
    NavigationStack {
        Text("Phrase")
        .toolbar(content: {
            Navbar(style: .standard, mode: .phrase)
        })
    }
    NavigationStack {
        Text("Other")
        .toolbar(content: {
            Navbar(style: .standard, mode: .other)
        })
    }
    NavigationStack {
        Text("Legacy")
        .toolbar(content: {
            Navbar(style: .standard, mode: .legacy)
        })
    }
}
