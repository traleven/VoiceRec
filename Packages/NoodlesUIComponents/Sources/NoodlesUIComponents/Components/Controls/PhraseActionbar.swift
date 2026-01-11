//
//  PhraseActionbar.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

struct PhraseActionbar: View {
    let style: Style

    var duration: Duration
    var progress: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack(alignment: .leading) {
                style.color.line.divider
                    .frame(height: 1)
                    .cornerRadius(10)
                
                style.color.icon.accent.foreground
                    .frame(height: 4)
                    .containerRelativeFrame(.horizontal, alignment: .leading) { length, axis in
                        switch axis {
                        case Axis.horizontal: return length * progress
                        case Axis.vertical: return length
                        }
                    }
                    .cornerRadius(10)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            HStack(alignment: .center, spacing: 12) {
                HStack(alignment: .center, spacing: 8) {
                    Circle()
                        .foregroundStyle(style.color.icon.accent.background)
                        .overlay {
                            Image(systemName: "play.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(style.color.icon.accent.foreground)
                        }
                        .frame(width: 40, height: 40, alignment: .center)
                    
                    Text(duration.formatted(Duration.TimeFormatStyle(pattern: .minuteSecond)))
                        .font(style.font.body.labelSmall)
                        .foregroundStyle(style.color.text.regular.primary)
                }
                
                Image(systemName: "repeat")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(style.color.icon.secondary.foreground)
                    .frame(width: 24, height: 24)
                
                Spacer()
                
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(style.color.icon.primary.foreground)
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "music.note")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(style.color.icon.primary.foreground)
                        .frame(width: 32, height: 32)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 40)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(height: 98.5, alignment: .bottom)
        .background(style.color.background.light)
    }
}

#Preview {
    VStack(spacing: 16) {
        Spacer()
        PhraseActionbar(
            style: .standard,
            duration: .minutes(0).add(seconds: 6),
            progress: 0.57
        )
        PhraseActionbar(
            style: .standard,
            duration: .minutes(10).add(seconds: 6),
            progress: 0.07
        )
        Spacer()
    }
    .background(Color.pink.opacity(0.1))
}
