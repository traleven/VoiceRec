//
//  PhraseAudiobar.swift
//  Noodles
//
//  Created by Ivan on 24/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

public struct PhraseAudiobar: View {
    public let style: Style

    public var content: [CGFloat]?
    public var duration: Duration?
    
    public init(style: Style, content: [CGFloat]? = nil, duration: Duration? = nil) {
        self.style = style
        self.content = content
        self.duration = duration
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 8) {
            PhraseAudioPlayer(style: style, content: content, duration: duration)
            
            if content != nil {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .background(style.color.icon.tertiary.background)
                    .foregroundStyle(style.color.icon.tertiary.foreground)
                    .mask(Circle())
                    .frame(width: 32, height: 32, alignment: .center)
            }
            
            Image(systemName: "ellipsis")
                .frame(width: 32, height: 32)
        }
        .frame(height: 40)
    }
}

#Preview {
    PhraseAudiobar(style: .standard, content: nil)
    PhraseAudiobar(style: .standard, content: Audiowaves.placeholder, duration: .minutes(3))

}
