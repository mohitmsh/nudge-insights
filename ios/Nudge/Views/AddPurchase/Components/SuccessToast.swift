//
//  SuccessToast.swift
//  Nudge
//
//  Created by Mohit Sharma on 6/12/2025.
//

import SwiftUI

struct SuccessToast: View {
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Success!")
                        .font(.proximaNova(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text("Purchase saved successfully")
                        .font(.proximaNova(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
