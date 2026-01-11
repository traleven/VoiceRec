//
//  FontStyle.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import SwiftUI

public struct FontStyle : Sendable {
    public let heading: Heading
    public let body: Body
    public let other: Other
    
    public init(heading: Heading, body: Body, other: Other) {
        self.heading = heading
        self.body = body
        self.other = other
    }
    
    public struct Heading : Sendable {
        public let displayTitle: Style
        public let title1, title2, title3, title4: Style
        
        public init(displayTitle: Style, title1: Style, title2: Style, title3: Style, title4: Style) {
            self.displayTitle = displayTitle
            self.title1 = title1
            self.title2 = title2
            self.title3 = title3
            self.title4 = title4
        }
    }
    
    public struct Body : Sendable {
        public let bodyXL, body, bodySmall: Style
        public let labelLarge, label, labelSmall, labelXS: Style
        public let caption, captionBold: Style
        
        public init(bodyXL: Style, body: Style, bodySmall: Style, labelLarge: Style, label: Style, labelSmall: Style, labelXS: Style, caption: Style, captionBold: Style) {
            self.bodyXL = bodyXL
            self.body = body
            self.bodySmall = bodySmall
            self.labelLarge = labelLarge
            self.label = label
            self.labelSmall = labelSmall
            self.labelXS = labelXS
            self.caption = caption
            self.captionBold = captionBold
        }
    }
    
    public struct Other : Sendable {
        public let emojiXL, emoji: Style
        
        public init(emojiXL: Style, emoji: Style) {
            self.emojiXL = emojiXL
            self.emoji = emoji
        }
    }
    
    public struct Style : Sendable {
        public let font: Font
        public let lineHeight: CGFloat
        public let lineSpacing: CGFloat
        public let letterSpacing: CGFloat
        
        public init(_ fontName: String, size: CGFloat, weight: Font.Weight, lineHeight: CGFloat, letterSpacing: CGFloat) {
            self.font = .custom(fontName, size: size).weight(weight)
            self.lineHeight = lineHeight
            self.lineSpacing = lineHeight - size
            self.letterSpacing = letterSpacing
        }
    }
}
