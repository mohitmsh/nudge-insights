//
//  TransactionsListView.swift
//  Nudge
//
//  Displays all transactions grouped by date
//  - Shows transactions in reverse chronological order
//  - Groups by Today, Yesterday, or date
//  - Pull to refresh support
//

import SwiftUI

struct TransactionsListView: View {
    @EnvironmentObject var viewModel: InsightsViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if viewModel.purchases.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(groupedPurchases.keys.sorted(by: >), id: \.self) { date in
                                Section {
                                    // Show newest transactions first within each day
                                    ForEach(groupedPurchases[date]?.sorted(by: { $0.timestamp > $1.timestamp }) ?? []) { purchase in
                                        TransactionRowView(purchase: purchase)
                                    }
                                } header: {
                                    SectionHeaderView(date: date)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    .refreshable {
                        await viewModel.loadData()
                    }
                }
            }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Computed Properties
    
    /// Groups purchases by date for section headers
    private var groupedPurchases: [Date: [Purchase]] {
        Dictionary(grouping: viewModel.purchases) { purchase in
            Calendar.current.startOfDay(for: purchase.timestamp)
        }
    }
    
    // MARK: - Subviews
    
    /// Empty state when no transactions exist
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "cart.badge.questionmark")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary.opacity(0.5))
            
            Text("No Transactions Yet")
                .font(.proximaNovaSemibold(size: 22))
                .foregroundColor(.textPrimary)
            
            Text("Start tracking your spending by adding your first purchase")
                .font(.proximaNova(size: 15))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

// MARK: - Section Header

/// Displays date headers (Today, Yesterday, or formatted date)
struct SectionHeaderView: View {
    let date: Date
    
    private var dateText: String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let purchaseDate = calendar.startOfDay(for: date)
        
        if purchaseDate == today {
            return "Today"
        } else if purchaseDate == yesterday {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d"
            return formatter.string(from: date)
        }
    }
    
    var body: some View {
        HStack {
            Text(dateText)
                .font(.proximaNovaSemibold(size: 15))
                .foregroundColor(.textSecondary)
                .textCase(.uppercase)
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}

// MARK: - Transaction Row

/// Individual transaction row with category icon and amount
struct TransactionRowView: View {
    let purchase: Purchase
    
    var body: some View {
        HStack(spacing: 16) {
            // Category Icon
            ZStack {
                Circle()
                    .fill(categoryColor.opacity(0.15))
                    .frame(width: 48, height: 48)
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(categoryColor)
            }
            
            // Transaction Details
            VStack(alignment: .leading, spacing: 4) {
                Text(purchase.category.rawValue)
                    .font(.proximaNovaSemibold(size: 16))
                    .foregroundColor(.textPrimary)
                
                Text(timeString)
                    .font(.proximaNova(size: 13))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            // Amount
            Text(Formatters.currency(purchase.amount))
                .font(.proximaNovaSemibold(size: 18))
                .foregroundColor(.coral)
        }
        .padding(16)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 2)
    }
    
    private var categoryIcon: String {
        switch purchase.category {
        case .foodDelivery:
            return "bag.fill"
        case .eatingOut:
            return "fork.knife"
        case .shopping:
            return "cart.fill"
        case .transport:
            return "car.fill"
        case .entertainment:
            return "ticket.fill"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
    
    private var categoryColor: Color {
        switch purchase.category {
        case .foodDelivery:
            return Color(hex: "FF6B6B")
        case .eatingOut:
            return Color(hex: "667EEA")
        case .shopping:
            return Color(hex: "FFA07A")
        case .transport:
            return Color(hex: "48BB78")
        case .entertainment:
            return Color(hex: "ED64A6")
        case .other:
            return Color(hex: "A0AEC0")
        }
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: purchase.timestamp)
    }
}

#Preview {
    TransactionsListView()
        .environmentObject(InsightsViewModel())
}
