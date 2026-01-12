//
//  PhraseAudioPlayerPhragment.swift
//  Noodles
//
//  Created by Ivan on 24/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

struct PhraseAudioPlayer: View {
    let style: Style

    var content: [CGFloat]?
    var duration: Duration?
    var progress: Float?
    
    private var icon: String {
        if content?.isEmpty == false && duration != nil {
            if progress != nil {
                return "pause.circle"
            } else {
                return "play.circle"
            }
        } else {
            return "mic.circle"
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Button(action: {}, label: {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .background(Circle()
                        .foregroundStyle(progress != nil ? style.color.icon.accent.background : style.color.icon.secondary.background)
                    )
                    .foregroundStyle(progress != nil ? style.color.icon.accent.foreground : style.color.icon.tertiary.foreground)
            })
            .buttonStyle(.plain)
            .padding(5)
            
            if let content {
                Audiowaves(style: style, values: content, progress: progress)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            
            if let duration {
                Text(duration.formatted(Duration.TimeFormatStyle(pattern: .minuteSecond(padMinuteToLength: 2))))
                    .font(style.font.body.labelSmall)
                    .foregroundColor(style.color.text.regular.secondary)
                    .frame(width: 48, height: 32, alignment: .leading)
            }
        }
        .padding(.trailing, 8)
        .padding(.vertical, 4)
        .frame(height: 40)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PhraseAudioPlayer(
        style: .standard,
        content: nil,
        duration: nil,
        progress: nil
    )
    
    PhraseAudioPlayer(
        style: .standard,
        content: Audiowaves.placeholder,
        duration: .minutes(10).add(seconds: 8),
        progress: nil
    )
    
    PhraseAudioPlayer(
        style: .standard,
        content: Audiowaves.placeholder,
        duration: .minutes(10).add(seconds: 8),
        progress: 0.5
    )
}
