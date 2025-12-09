//
//  AmountSection.swift
//  Nudge
//
//  Created by Mohit Sharma on 6/12/2025.
//

import SwiftUI

struct AmountSection: View {
    @Binding var amount: String
    @FocusState.Binding var isAmountFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Amount")
                .font(.proximaNova(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .tracking(1.2)
            
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("$")
                    .font(.proximaNova(size: 52, weight: .semibold))
                    .foregroundColor(.primary)
                
                TextField("0", text: $amount)
                    .font(.proximaNova(size: 52, weight: .semibold))
                    .foregroundColor(.primary)
                    .keyboardType(.decimalPad)
                    .focused($isAmountFocused)
                    .onChange(of: amount) { _ in
                        withAnimation(.spring(response: 0.3)) {}
                    }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.cardShadow, radius: 20, x: 0, y: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.borderColor, lineWidth: 1)
            )
        }
    }
}
