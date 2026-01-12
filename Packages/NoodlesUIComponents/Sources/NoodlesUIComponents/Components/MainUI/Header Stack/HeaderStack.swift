//
//  HeaderStack.swift
//  NoodlesUIComponents
//
//  Created by Ivan on 11/01/2026.
//

import SwiftUI
import NoodlesDesignSystem

public struct HeaderStack : View {
    private let style: Style
    private let navbarMode: Navbar.Mode
    private let controlsbarMode: PageControlsbar.Mode
    private let searchText: Binding<String>
    
    @ViewBuilder
    public var body: some View {
        VStack(spacing: 0) {
            Navbar(style: style, mode: navbarMode)
            PageControlsbar(style: style, mode: controlsbarMode, searchText: searchText)
        }
    }
}
