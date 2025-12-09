//
//  QuickStatCard.swift
//  Nudge
//
//  Created by Mohit Sharma on 6/12/2025.
//

import SwiftUI

struct QuickStatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.proximaNova(size: 10))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Text(value)
                    .font(.proximaNova(size: 16, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 3)
    }
}
