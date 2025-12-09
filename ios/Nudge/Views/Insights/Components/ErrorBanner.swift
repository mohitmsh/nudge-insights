//
//  ErrorBanner.swift
//  Nudge
//
//  Created by Mohit Sharma on 8/12/2025.
//

import SwiftUI

struct ErrorBanner: View {
    let message: String
    let onDismiss: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
                .font(.system(size: 20))
            
            Text(message)
                .font(.proximaNova(size: 14))
                .foregroundColor(.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.textSecondary.opacity(0.6))
                    .font(.system(size: 20))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.orange.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    ErrorBanner(message: "Failed to load data. Please try again.") {
        print("Dismissed")
    }
    .padding()
}
