//
//  CategorySection.swift
//  Nudge
//
//  Created by Mohit Sharma on 6/12/2025.
//

import SwiftUI

struct CategorySection: View {
    @Binding var selectedCategory: Category
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category")
                .font(.proximaNova(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .tracking(1.2)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(Category.allCases, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            selectedCategory = category
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Category Button Component
struct CategoryButton: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(isSelected ? category.color : category.color.opacity(0.15))
                        .frame(width: 52, height: 52)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(isSelected ? .white : category.color)
                }
                
                Text(category.rawValue)
                    .font(.proximaNova(size: 11, weight: .semibold))
                    .foregroundColor(isSelected ? category.color : .primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.cardBackground)
                    .shadow(
                        color: isSelected ? category.color.opacity(0.3) : Color.cardShadow,
                        radius: isSelected ? 12 : 8,
                        x: 0,
                        y: isSelected ? 6 : 4
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isSelected ? category.color.opacity(0.3) : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.03 : 1.0)
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
