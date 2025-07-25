//
//  HSeparator.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI

struct HSeparator: View {
    @Environment(\.style) private var style
    
    var body: some View {
        style.color.line.separator.frame(height: 1)
    }
}

#Preview {
    HSeparator()
}
