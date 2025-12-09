//
//  AppStyle.swift
//  Nudge
//
//  Created by Mohit Sharma on 6/12/2025.
//

import SwiftUI

// MARK: - App Colors
extension Color {
    static let appBackground = Color(red: 0.98, green: 0.97, blue: 0.95)
    static let cardBackground = Color.white
    
    // Coral theme colors
    static let coral = Color(hex: "FF6B6B")
    static let coralLight = Color(hex: "FFB6B6")
    
    // Text colors
    static let textPrimary = Color(hex: "1A1A1A")
    static let textSecondary = Color(hex: "666666")
    
    // Premium gradient colors
    static let primaryGradientStart = Color(red: 0.4, green: 0.6, blue: 1.0)
    static let primaryGradientEnd = Color(red: 0.2, green: 0.4, blue: 0.9)
    
    // Subtle shadows and borders
    static let cardShadow = Color.black.opacity(0.08)
    static let borderColor = Color.black.opacity(0.06)
    
    // Hex color initializer
    // Helper function to convert hex to rgb
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Custom Fonts
extension Font {
    static func proximaNova(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .semibold, .bold, .heavy, .black:
            fontName = "ProximaNova-Semibold"
        default:
            fontName = "ProximaNova-Regular"
        }
        return .custom(fontName, size: size)
    }
    
    static func proximaNovaSemibold(size: CGFloat) -> Font {
        return .custom("ProximaNova-Semibold", size: size)
    }
}
