//
//  ListGradientOverlay.swift
//  Noodles
//
//  Created by Ivan on 07/07/2025.
//

import SwiftUI
import NoodlesDesignSystem
import NoodlesThemeStandard

struct ListGradientOverlay: View {
    let style: Style

    enum Edge { case top, bottom }
    
    var edge: Edge
    
    var body: some View {
        LinearGradient(
            stops: [
                Gradient.Stop(color: style.palette.transparent, location: 0.00),
                Gradient.Stop(color: style.color.background.light, location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: edge == .bottom ? 0 : 1),
            endPoint: UnitPoint(x: 0.5, y: edge == .bottom ? 1 : 0)
        )
        .frame(height: 24)
    }
}

#Preview {
    VStack {
        ListGradientOverlay(style: .standard, edge: .top)
        Spacer().frame(height: 100)
        ListGradientOverlay(style: .standard, edge: .bottom)
    }
    .background(Color.blue)
}
