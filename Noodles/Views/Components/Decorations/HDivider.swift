//
//  HDivider.swift
//  Noodles
//
//  Created by Ivan on 25/07/2025.
//

import SwiftUI

struct HDivider: View {
    @Environment(\.style) private var style
    
    var body: some View {
        style.color.line.divider.frame(height: 1)
    }
}

#Preview {
    HDivider()
}
