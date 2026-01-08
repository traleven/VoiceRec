//
//  Style.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import Foundation
import SwiftUI
import NoodlesDesignSystem
import FontInter

extension Style {
    public static let standard: Style = {
        let importedFonts = Font.Inter.register()
        print(importedFonts)
        return .init(
            font: .standard,
            color: .standard,
            palette: .standard,
        )
    }()
}
