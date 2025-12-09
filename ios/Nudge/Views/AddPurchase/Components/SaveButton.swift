//
//  SaveButton.swift
//  Nudge
//
//  Created by Mohit Sharma on 6/12/2025.
//

import SwiftUI

struct SaveButton: View {
    let isValid: Bool
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                    Text("Save Purchase")
                        .font(.proximaNova(size: 17, weight: .semibold))
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                Group {
                    if isValid {
                        LinearGradient(
                            colors: [Color.primaryGradientStart, Color.primaryGradientEnd],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        LinearGradient(
                            colors: [Color.gray.opacity(0.6), Color.gray.opacity(0.5)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(
                color: isValid ? Color.blue.opacity(0.4) : Color.clear,
                radius: 15,
                x: 0,
                y: 8
            )
            .scaleEffect(isValid ? 1.0 : 0.98)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isValid)
        }
        .disabled(!isValid || isLoading)
        .padding(.top, 8)
    }
}
