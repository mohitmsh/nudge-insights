//
//  InsightsView.swift
//  Nudge
//
//  Created by Mohit Sharma on 6/12/2025.
//

import SwiftUI

struct InsightsView: View {
    @EnvironmentObject var viewModel: InsightsViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Premium gradient background
                LinearGradient(
                    colors: [
                        Color.appBackground,
                        Color.appBackground.opacity(0.9)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.purchases.isEmpty {
                    ProgressView()
                        .scaleEffect(1.5)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Header
                            InsightHeaderView(
                                timeframeTitle: timeframeTitle,
                                dateRangeText: dateRangeText,
                                selectedTimeframe: viewModel.selectedTimeframe,
                                onTimeframeChange: { timeframe in
                                    viewModel.selectedTimeframe = timeframe
                                }
                            )
                            
                            // Error message if any
                            if let error = viewModel.errorMessage {
                                ErrorBanner(message: error) {
                                    viewModel.errorMessage = nil
                                }
                            }
                        
                            // Chart + Money Out + Stats Combined
                            ChartMoneyOutStatsCard(
                                totalSpent: viewModel.totalSpent,
                                weeklySpending: viewModel.weeklySpending,
                                timeframe: viewModel.selectedTimeframe
                            )
                            .overlay {
                                if viewModel.isLoading {
                                    ZStack {
                                        Color.cardBackground.opacity(0.8)
                                        ProgressView()
                                            .scaleEffect(1.2)
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                            }
                            
                            // Top Categories
                            TopCategoriesCard(
                                categories: viewModel.topCategories,
                                totalSpent: viewModel.totalSpent
                            )
                            .overlay {
                                if viewModel.isLoading {
                                    ZStack {
                                        Color.cardBackground.opacity(0.8)
                                        ProgressView()
                                            .scaleEffect(1.2)
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                            }
                            
                            // AI Insights Card
                            AIInsightsCard(
                                insights: viewModel.insights,
                                isLoading: viewModel.isLoadingInsights
                            )
                            
                            // Budget Card
                            BudgetCard(
                                budget: viewModel.budget,
                                totalSpent: viewModel.totalSpent,
                                budgetPercentage: viewModel.budgetPercentage,
                                budgetRemaining: viewModel.budgetRemaining
                            )
                            
                            // Quick Stats Grid
                            quickStatsGrid
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                    }
                    .refreshable {
                        await viewModel.loadData()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Quick Stats Grid
    private var quickStatsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            QuickStatCard(
                icon: "cart.fill",
                title: "Purchases",
                value: "\(viewModel.purchases.count)",
                color: .blue
            )
            QuickStatCard(
                icon: "calendar",
                title: "This Week",
                value: Formatters.currency(viewModel.weeklySpending.reduce(0) { $0 + $1.amount }),
                color: .purple
            )
            QuickStatCard(
                icon: "chart.line.uptrend.xyaxis",
                title: "Avg/Day",
                value: Formatters.currency(viewModel.weeklySpending.isEmpty ? 0 : viewModel.weeklySpending.reduce(0) { $0 + $1.amount } / Double(viewModel.weeklySpending.count)),
                color: .green
            )
            QuickStatCard(
                icon: "star.fill",
                title: "Top Category",
                value: viewModel.topCategories.first?.category.rawValue ?? "None",
                color: .orange
            )
        }
    }
    
    // MARK: - Computed Properties
    private var timeframeTitle: String {
        switch viewModel.selectedTimeframe {
        case .week: return "This week"
        case .month: return "This month"
        case .year: return "This year"
        }
    }
    
    private var dateRangeText: String {
        let calendar = Calendar.current
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        
        switch viewModel.selectedTimeframe {
        case .week:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
            let year = calendar.component(.year, from: now)
            return "\(formatter.string(from: weekAgo)) - \(formatter.string(from: now)) \(year)"
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            let year = calendar.component(.year, from: now)
            return "\(formatter.string(from: monthAgo)) - \(formatter.string(from: now)) \(year)"
        case .year:
            let year = calendar.component(.year, from: now)
            return "Jan - Dec \(year)"
        }
    }
}

#Preview {
    InsightsView()
        .environmentObject(InsightsViewModel())
}
