//
//  Style.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import Foundation

public final class Style : Sendable {
    public let font: FontStyle
    public let color: ColorStyle
    public let palette: ColorPalette
    
    public init(font: FontStyle, color: ColorStyle, palette: ColorPalette) {
        self.font = font
        self.color = color
        self.palette = palette
    }
}
