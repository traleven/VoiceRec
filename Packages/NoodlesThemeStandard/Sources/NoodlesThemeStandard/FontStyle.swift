//
//  FontStyle.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import SwiftUI
import NoodlesDesignSystem

extension FontStyle {
    public static let standard = FontStyle(
        heading: .init(
            displayTitle: .init("InterDisplay-Bold",     size: 32, weight: .bold,     lineHeight: 40, letterSpacing: -0.80),
            title1:       .init("InterDisplay-Bold",     size: 28, weight: .bold,     lineHeight: 34, letterSpacing: -0.85),
            title2:       .init("InterDisplay-SemiBold", size: 22, weight: .semibold, lineHeight: 28, letterSpacing: -0.55),
            title3:       .init("InterDisplay-SemiBold", size: 20, weight: .semibold, lineHeight: 26, letterSpacing: -0.50),
            title4:       .init("InterDisplay-SemiBold", size: 14, weight: .semibold, lineHeight: 20, letterSpacing: -0.38)
        ),
        body: .init(
            bodyXL:     .init("Inter-Medium",   size: 32, weight: .medium,  lineHeight: 41, letterSpacing: -0.80),
            body:       .init("Inter-Regular",  size: 17, weight: .regular, lineHeight: 24, letterSpacing: -0.43),
            bodySmall:  .init("Inter-Regular",  size: 15, weight: .regular, lineHeight: 20, letterSpacing: -0.38),
            labelLarge: .init("Inter-Medium",   size: 18, weight: .medium,  lineHeight: 25, letterSpacing: -0.57),
            label:      .init("Inter-Medium",   size: 17, weight: .medium,  lineHeight: 24, letterSpacing: -0.51),
            labelSmall: .init("Inter-Medium",   size: 14, weight: .medium,  lineHeight: 18, letterSpacing: -0.45),
            labelXS:    .init("Inter-Medium",   size: 13, weight: .medium,  lineHeight: 18, letterSpacing: -0.33),
            caption:    .init("Inter-Regular",  size: 12, weight: .regular, lineHeight: 16, letterSpacing: -0.36),
            captionBold:.init("Inter-SemiBold", size: 12, weight: .semibold,lineHeight: 16, letterSpacing: -0.36),
        ),
        other: .init(
            emojiXL:    .init("Inter-Regular",  size: 80, weight: .regular, lineHeight: 80, letterSpacing:  0.00),
            emoji:      .init("Inter-Medium",   size: 24, weight: .medium, lineHeight: 24, letterSpacing:  0.00)
        ),
    )
}
