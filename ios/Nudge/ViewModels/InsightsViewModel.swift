//
//  InsightsViewModel.swift
//  Nudge
//
//  Manages all data for the Insights and Transactions tabs
//  - Fetches purchases from backend
//  - Calculates spending analytics
//  - Manages AI insights
//  - Handles timeframe filtering (week/month/year)
//

import Foundation
import SwiftUI
import Combine

@MainActor
class InsightsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// All purchases from the backend
    @Published var purchases: [Purchase] = []
    
    /// AI-generated insights
    @Published var insights: [NudgeInsight] = []
    
    /// Loading state for main data
    @Published var isLoading = false
    
    /// Loading state specifically for AI insights
    @Published var isLoadingInsights = false
    
    /// Chart data for spending over time
    @Published var weeklySpending: [DaySpending] = []
    
    /// Top spending categories
    @Published var topCategories: [CategorySpending] = []
    
    /// Total amount spent in selected timeframe
    @Published var totalSpent: Double = 0
    
    /// Monthly budget amount
    @Published var budget: Double = 5000
    
    /// Currently selected timeframe - automatically refreshes insights when changed
    @Published var selectedTimeframe: Timeframe = .week {
        didSet {
            Task {
                isLoading = true
                await fetchInsightsForTimeframe()
                calculateInsights()
                isLoading = false
            }
        }
    }
    
    /// Error message to display to user
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    
    private let networkService = NetworkService.shared
    
    // MARK: - Types
    
    enum Timeframe: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    // MARK: - Initialization
    
    init() {
        Task {
            await loadData()
        }
    }
    
    // MARK: - Data Loading
    
    /// Loads all data from backend
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            purchases = try await networkService.fetchPurchases()
            await fetchInsightsForTimeframe()
            calculateInsights()
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    /// Fetches AI insights for the current timeframe
    func fetchInsightsForTimeframe() async {
        isLoadingInsights = true
        
        do {
            let timeframeString = selectedTimeframe.rawValue.lowercased()
            insights = try await networkService.fetchInsights(timeframe: timeframeString)
        } catch {
            errorMessage = "Failed to load insights: \(error.localizedDescription)"
        }
        
        isLoadingInsights = false
    }
    
    // MARK: - Analytics Calculations
    
    /// Calculates all analytics based on selected timeframe
    private func calculateInsights() {
        let calendar = Calendar.current
        let now = Date()
        
        // Filter purchases by selected timeframe
        let filteredPurchases: [Purchase]
        switch selectedTimeframe {
        case .week:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
            filteredPurchases = purchases.filter { $0.timestamp >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
            filteredPurchases = purchases.filter { $0.timestamp >= monthAgo }
        case .year:
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: now)!
            filteredPurchases = purchases.filter { $0.timestamp >= yearAgo }
        }
        
        totalSpent = filteredPurchases.reduce(0) { $0 + $1.amount }
        calculateWeeklySpending(from: filteredPurchases)
        calculateTopCategories(from: filteredPurchases)
    }
    
    /// Creates chart data for spending over time
    private func calculateWeeklySpending(from purchases: [Purchase]) {
        let calendar = Calendar.current
        let now = Date()
        
        var dailyTotals: [Date: Double] = [:]
        
        // Create buckets based on selected timeframe
        let days: Int
        switch selectedTimeframe {
        case .week:
            days = 7
        case .month:
            days = 30
        case .year:
            days = 365
        }
        
        // Initialize all days with zero spending
        for i in 0..<days {
            if let date = calendar.date(byAdding: .day, value: -i, to: now) {
                let startOfDay = calendar.startOfDay(for: date)
                dailyTotals[startOfDay] = 0
            }
        }
        
        // Sum up purchases for each day
        for purchase in purchases {
            let startOfDay = calendar.startOfDay(for: purchase.timestamp)
            dailyTotals[startOfDay, default: 0] += purchase.amount
        }
        
        weeklySpending = dailyTotals
            .map { DaySpending(date: $0.key, amount: $0.value) }
            .sorted { $0.date < $1.date }
    }
    
    /// Calculates top 5 spending categories
    private func calculateTopCategories(from purchases: [Purchase]) {
            var categoryTotals: [Category: Double] = [:]
            
            for purchase in purchases {
                categoryTotals[purchase.category, default: 0] += purchase.amount
            }
            
            topCategories = categoryTotals
                .map { CategorySpending(category: $0.key, amount: $0.value) }
                .sorted { $0.amount > $1.amount }
                .prefix(5)
                .map { $0 }
        }
        
        // MARK: - Computed Properties
        
        /// Percentage of budget spent (0.0 to 1.0)
        var budgetPercentage: Double {
            guard budget > 0 else { return 0 }
            return min(totalSpent / budget, 1.0)
        }
        
        /// Amount of budget remaining
        var budgetRemaining: Double {
            max(budget - totalSpent, 0)
        }
    }
    
    // MARK: - Supporting Models
    
    /// Represents spending for a single day (used in charts)
    struct DaySpending: Identifiable {
        let id = UUID()
        let date: Date
        let amount: Double
    }
    
    /// Represents total spending for a category
    struct CategorySpending: Identifiable {
        let id = UUID()
        let category: Category
        let amount: Double
    }

