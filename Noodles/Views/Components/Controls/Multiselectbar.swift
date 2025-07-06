//
//  Multiselectbar.swift
//  Noodles
//
//  Created by Ivan on 03/07/2025.
//

import SwiftUI

struct Multiselectbar: View {
    @Environment(\.style) private var style
    var hasSelected: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Text(hasSelected ? "Unselect all" : "Select all")
                    .font(style.font.body.label)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(style.color.text.button.secondary)
                Spacer()
                Text("Cancel")
                    .font(style.font.body.label)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(style.color.text.button.secondary)
            }
            .padding(0)
            .frame(maxWidth: .infinity, minHeight: 32, maxHeight: 32, alignment: .center)
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
        .padding(.bottom, 12)
    }
}

#Preview {
    Multiselectbar(hasSelected: false)
    Multiselectbar(hasSelected: true)
}
