//
//  FontStyle.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import SwiftUI

extension FontStyle {
    static let standard = FontStyle(
        heading: .init(
            displayTitle: .init(font: .custom("InterDisplay-Bold",     size: 34).weight(.bold),     lineHeight: 41, letterSpacing: -0.85),
            title1:       .init(font: .custom("InterDisplay-Bold",     size: 28).weight(.bold),     lineHeight: 34, letterSpacing: -0.70),
            title2:       .init(font: .custom("InterDisplay-SemiBold", size: 22).weight(.semibold), lineHeight: 28, letterSpacing: -0.55),
            title3:       .init(font: .custom("InterDisplay-SemiBold", size: 20).weight(.semibold), lineHeight: 26, letterSpacing: -0.50),
            title4:       .init(font: .custom("InterDisplay-SemiBold", size: 15).weight(.semibold), lineHeight: 20, letterSpacing: -0.375)
        ),
        body: .init(
            bodyXL:     .init(font: .custom("Inter-Medium",  size: 32).weight(.medium),  lineHeight: 41, letterSpacing: -0.8),
            body:       .init(font: .custom("Inter-Regular", size: 17).weight(.regular), lineHeight: 24, letterSpacing: -0.43),
            bodySmall:  .init(font: .custom("Inter-Regular", size: 15).weight(.regular), lineHeight: 20, letterSpacing: -0.375),
            labelLarge: .init(font: .custom("Inter-Medium",  size: 19).weight(.medium),  lineHeight: 25, letterSpacing: -0.57),
            label:      .init(font: .custom("Inter-Medium",  size: 17).weight(.medium),  lineHeight: 24, letterSpacing: -0.51),
            labelSmall: .init(font: .custom("Inter-Medium",  size: 15).weight(.medium),  lineHeight: 18, letterSpacing: -0.45),
            caption:    .init(font: .custom("Inter-Regular", size: 12).weight(.regular), lineHeight: 16, letterSpacing: -0.3),
            captionBold:.init(font: .custom("Inter-SemiBold",size: 12).weight(.semibold),lineHeight: 16, letterSpacing: -0.3)
        )
    )
}

struct FontStyle {
    let heading: Heading
    let body: Body
    
    struct Heading {
        let displayTitle: Style
        let title1, title2, title3, title4: Style
    }
    struct Body {
        let bodyXL, body, bodySmall: Style
        let labelLarge, label, labelSmall: Style
        let caption, captionBold: Style
    }
    struct Style {
        let font: Font
        let lineHeight: Double
        let letterSpacing: Double
    }
}
