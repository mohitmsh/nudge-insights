//
//  BudgetCard.swift
//  Nudge
//
//  Created by Mohit Sharma on 6/12/2025.
//

import SwiftUI

struct BudgetCard: View {
    let budget: Double
    let totalSpent: Double
    let budgetPercentage: Double
    let budgetRemaining: Double
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("Budget")
                    .font(.proximaNova(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
                Text(Formatters.currency(budget))
                    .font(.proximaNova(size: 15, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            
            // Progress Bar
            VStack(alignment: .leading, spacing: 8) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 12)
                        
                        // Progress
                        RoundedRectangle(cornerRadius: 8)
                            .fill(budgetPercentage >= 0.9 ? Color.red : Color(hex: "FF6B6B"))
                            .frame(width: geometry.size.width * CGFloat(budgetPercentage), height: 12)
                    }
                }
                .frame(height: 12)
                
                // Budget Info
                HStack {
                    Text("Spent: \(Formatters.currency(totalSpent))")
                        .font(.proximaNova(size: 13))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Remaining: \(Formatters.currency(budgetRemaining))")
                        .font(.proximaNova(size: 13))
                        .foregroundColor(budgetRemaining > 0 ? .green : .red)
                }
            }
            
            // Percentage
            Text("\(Int(budgetPercentage * 100))% of budget used")
                .font(.proximaNova(size: 12))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(18)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.cardShadow, radius: 10, x: 0, y: 4)
    }
}
