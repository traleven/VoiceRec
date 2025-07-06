//
//  Style.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import Foundation

final class Style {
    let font: FontStyle
    let color: ColorStyle
    let palette: ColorPalette
    
    init(font: FontStyle, color: ColorStyle, palette: ColorPalette) {
        self.font = font
        self.color = color
        self.palette = palette
    }
}
