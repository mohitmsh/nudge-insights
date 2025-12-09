//
//  AddPurchaseView.swift
//  Nudge
//
//  Created by Mohit Sharma on 6/12/2025.
//

import SwiftUI
import Foundation

struct AddPurchaseView: View {
    @StateObject private var viewModel = AddPurchaseViewModel()
    @ObservedObject var insightsViewModel: InsightsViewModel
    @FocusState private var isAmountFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Premium gradient background
                LinearGradient(
                    colors: [
                        Color.appBackground,
                        Color.appBackground.opacity(0.8)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Amount Input Section
                        AmountSection(
                            amount: $viewModel.amount,
                            isAmountFocused: $isAmountFocused
                        )
                        .transition(.scale.combined(with: .opacity))
                        
                        // Category Selection
                        CategorySection(selectedCategory: $viewModel.selectedCategory)
                            .transition(.scale.combined(with: .opacity))
                        
                        // Date Section
                        DateSection(
                            useCustomDate: $viewModel.useCustomDate,
                            customDate: $viewModel.customDate
                        )
                        .transition(.scale.combined(with: .opacity))
                        
                        // Save Button
                        SaveButton(
                            isValid: viewModel.isValid,
                            isLoading: viewModel.isLoading
                        ) {
                            isAmountFocused = false
                            Task {
                                await viewModel.savePurchase()
                                // Refresh insights after successful save
                                if viewModel.errorMessage == nil {
                                    await insightsViewModel.loadData()
                                }
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                }
                
                // Success Toast
                if viewModel.showSuccess {
                    SuccessToast()
                        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: viewModel.showSuccess)
                }
            }
            .navigationTitle("Add Purchase")
            .navigationBarTitleDisplayMode(.large)
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AddPurchaseView(insightsViewModel: InsightsViewModel())
}
