//
//  PageControlsbar.swift
//  NoodlesUIComponents
//
//  Created by Ivan on 11/01/2026.
//

import SwiftUI
import NoodlesDesignSystem

public struct PageControlsbar : View {
    private let style: Style
    private let mode: Mode
    private let searchText: Binding<String>
    
    public init(
        style: Style,
        mode: Mode,
        searchText: Binding<String>
    ) {
        self.style = style
        self.mode = mode
        self.searchText = searchText
    }
    
    @ViewBuilder
    public var body: some View {
        VStack(spacing: 0) {
            Searchbar(style: style, text: searchText)
            ContentControls()
            Sortbar(style: style, title: "Recent")
        }
        .padding(.top, topPadding)
    }
    
    private var topPadding: CGFloat {
        switch mode {
        case .Phrases: return 4
        case .Lessons, .Sortbar: return 8
        case .MultiSelect: return 58
        case .Empty: return 0
        }
    }
}

extension PageControlsbar {
    public enum Mode : Sendable {
        case Phrases, Lessons, Sortbar, MultiSelect, Empty
    }
}

#Preview {
    PageControlsbar(
        style: .standard,
        mode: .Phrases,
        searchText: .constant("Phrases")
    )
    PageControlsbar(
        style: .standard,
        mode: .Lessons,
        searchText: .constant("Lessons")
    )
    PageControlsbar(
        style: .standard,
        mode: .Sortbar,
        searchText: .constant("Sortbar")
    )
    PageControlsbar(
        style: .standard,
        mode: .MultiSelect,
        searchText: .constant("MultiSelect")
    )
    PageControlsbar(
        style: .standard,
        mode: .Empty,
        searchText: .constant("Empty")
    )
}
