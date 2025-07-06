//
//  Color+Hex.swift
//  Noodles
//
//  Created by Ivan on 02/07/2025.
//

import SwiftUI

extension Color {
    init(_ hex: String, opacity: Double) {
        let hex = Int(hex.trimmingCharacters(in: ["#"]).capitalized, radix: 16)!
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double((hex >> 0) & 0xFF) / 255.0,
            opacity: opacity
        )
    }
    
    init(_ hex: String) {
        let hex = Int(hex.trimmingCharacters(in: ["#"]).capitalized, radix: 16)!
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double((hex >> 0) & 0xFF) / 255.0
        )
    }
}
