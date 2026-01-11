//
//  LessonCover.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI
import NoodlesDesignSystem

struct LessonCover: View {
    let style: Style
    
    var body: some View {
        Image("Checkers")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 393, height: 152)
            .clipped()
            .overlay(alignment: .topTrailing) {
                SecondaryButton(style: style, action: {}, label: "Change image", icon: "plus.circle.fill")
                    .padding(16)
            }
    }
}

#Preview {
    LessonCover(style: .standard)
}
