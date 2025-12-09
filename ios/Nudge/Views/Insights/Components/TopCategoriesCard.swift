//
//  TopCategoriesCard.swift
//  Nudge
//
//  Created by Mohit Sharma on 6/12/2025.
//

import SwiftUI

struct TopCategoriesCard: View {
    let categories: [CategorySpending]
    let totalSpent: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Top spending categories")
                .font(.proximaNova(size: 14, weight: .semibold))
                .foregroundColor(.primary)
            
            if !categories.isEmpty {
                VStack(spacing: 14) {
                    ForEach(categories) { cat in
                        CategoryRow(category: cat.category, amount: cat.amount, totalSpent: totalSpent)
                    }
                }
            }
        }
        .padding(18)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.cardShadow, radius: 10, x: 0, y: 4)
    }
}

struct CategoryRow: View {
    let category: Category
    let amount: Double
    let totalSpent: Double
    
    private var percentage: Double {
        guard totalSpent > 0 else { return 0 }
        return amount / totalSpent
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(category.color.opacity(0.15))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: category.icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(category.color)
                )
            
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(category.rawValue)
                        .font(.proximaNova(size: 14, weight: .semibold))
                    Spacer()
                    Text("\(Int(percentage * 100))%")
                        .font(.proximaNova(size: 12))
                        .foregroundColor(.secondary)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 5)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(category.color)
                            .frame(width: geo.size.width * percentage, height: 5)
                    }
                }
                .frame(height: 5)
            }
            
            Text(Formatters.currency(amount))
                .font(.proximaNova(size: 14, weight: .semibold))
        }
    }
}
