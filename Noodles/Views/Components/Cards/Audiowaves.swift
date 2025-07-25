//
//  Audiowaves.swift
//  Noodles
//
//  Created by Ivan on 24/07/2025.
//

import SwiftUI

struct Audiowaves: View {
    @Environment(\.style) private var style
    
    static let placeholder: [CGFloat] = [2, 4, 4, 4, 6, 12, 8, 18, 6, 24, 8, 14, 12, 8, 6, 4, 6, 12, 16, 24, 22, 12, 4, 6, 12, 14, 6, 20, 12, 4]
    
    var values: [CGFloat] = Audiowaves.placeholder
    var progress: Float? = nil
    
    private func color(for index: Int) -> Color {
        if let progress, values.count > 0 {
            return Float(index) / Float(values.count) < progress ? style.color.icon.accent.foreground : style.color.icon.accent.background
        } else {
            return style.color.icon.tertiary.outline
        }
    }
    
    var body: some View {
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
    Audiowaves()
    Audiowaves(progress: 0.5)
    Audiowaves(progress: 0.5)
        .frame(width: 60)
}
