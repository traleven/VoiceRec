//
//  Filterbar.swift
//  Noodles
//
//  Created by Ivan on 03/07/2025.
//

import SwiftUI

struct Filterbar: View {
    @Environment(\.style) private var style
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ScrollView(.horizontal) {
                HStack(alignment: .center, spacing: 4) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                    ForEach(["All phrases", "Tags", "Person", "Speaker"], id: \.self) { category in
                        HStack(alignment: .center, spacing: 6) {
                            // Body/Label Small
                            Text(category)
                                .font(style.font.body.labelSmall)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(style.color.text.button.secondary)
                            Image(systemName: "arrowtriangle.down.fill")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(style.color.text.button.secondary)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .cornerRadius(8)
                    }
                }
                .padding(.leading, 0)
                .padding(.trailing, 16)
                .padding(.vertical, 0)
            }.scrollIndicators(.never)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }
}

#Preview {
    Filterbar()
}
