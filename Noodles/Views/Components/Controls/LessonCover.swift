//
//  LessonCover.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI

struct LessonCover: View {
    var body: some View {
        Image("Checkers")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 393, height: 152)
            .clipped()
            .overlay(alignment: .topTrailing) {
                SecondaryButton(action: {}, label: "Change image", icon: "plus.circle.fill")
                    .padding(16)
            }
    }
}

#Preview {
    LessonCover()
}
