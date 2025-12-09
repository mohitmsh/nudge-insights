//
//  AddPurchaseViewModel.swift
//  Nudge
//
//  Created by Mohit Sharma on 6/12/2025.
//

import Foundation
import Combine

@MainActor
class AddPurchaseViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var selectedCategory: Category = .eatingOut
    @Published var customDate: Date = Date()
    @Published var useCustomDate: Bool = false
    @Published var isLoading: Bool = false
    @Published var showSuccess: Bool = false
    @Published var errorMessage: String?
    
    private let networkService = NetworkService.shared
    
    func savePurchase() async {
        guard let amountValue = Double(amount), amountValue > 0 else {
            errorMessage = "Please enter a valid amount"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let purchase = Purchase(
            amount: amountValue,
            category: selectedCategory,
            timestamp: useCustomDate ? customDate : Date()
        )
        
        do {
            try await networkService.savePurchase(purchase)
            
            // Reset form
            amount = ""
            selectedCategory = .eatingOut
            useCustomDate = false
            customDate = Date()
            showSuccess = true
            
            // Hide success message after 2 seconds
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            showSuccess = false
        } catch {
            errorMessage = "Failed to save purchase: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    var isValid: Bool {
        guard let amountValue = Double(amount) else { return false }
        return amountValue > 0
    }
}
