//
//  Audiowaves.swift
//  Noodles
//
//  Created by Ivan on 24/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

public struct Audiowaves: View {
    public let style: Style

    public static let placeholder: [CGFloat] = [2, 4, 4, 4, 6, 12, 8, 18, 6, 24, 8, 14, 12, 8, 6, 4, 6, 12, 16, 24, 22, 12, 4, 6, 12, 14, 6, 20, 12, 4]
    
    public var values: [CGFloat] = Audiowaves.placeholder
    public var progress: Float? = nil
    
    private func color(for index: Int) -> Color {
        if let progress, values.count > 0 {
            return Float(index) / Float(values.count) < progress ? style.color.icon.accent.foreground : style.color.icon.accent.background
        } else {
            return style.color.icon.tertiary.outline
        }
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(values.indices) { index in
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(color(for: index))
                    .frame(width: 4, height: values[index])
                    .frame(maxWidth: .infinity)
            }
            
        }
    }
}

#Preview {
    Audiowaves(style: .standard, )
    Audiowaves(style: .standard, progress: 0.5)
    Audiowaves(style: .standard, progress: 0.5)
        .frame(width: 60)
}
