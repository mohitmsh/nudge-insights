//
//  ChartMoneyOutStatsCard.swift
//  Nudge
//
//  Created by Mohit Sharma on 6/12/2025.
//

import SwiftUI
import Charts

struct ChartMoneyOutStatsCard: View {
    let totalSpent: Double
    let weeklySpending: [DaySpending]
    let timeframe: InsightsViewModel.Timeframe
    
    var body: some View {
        VStack(spacing: 18) {
            // Money Out Section
            VStack(spacing: 8) {
                Text("Money out")
                    .font(.proximaNova(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
                
                Text(Formatters.currency(totalSpent))
                    .font(.proximaNova(size: 36, weight: .semibold))
                    .foregroundColor(Color(hex: "FF6B6B"))
                
                HStack(spacing: 3) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 9, weight: .bold))
                    Text("$10 from last week")
                        .font(.proximaNova(size: 11))
                }
                .foregroundColor(Color(hex: "FF6B6B").opacity(0.7))
            }
            
            Divider().padding(.vertical, 4)
            
            // Chart Section
            if !weeklySpending.isEmpty {
                let avgAmount = weeklySpending.reduce(0) { $0 + $1.amount } / Double(max(weeklySpending.count, 1))
                
                Chart {
                    ForEach(weeklySpending) { day in
                        BarMark(
                            x: .value("Day", day.date, unit: .day),
                            y: .value("Amount", day.amount)
                        )
                        .foregroundStyle(day.amount > avgAmount ? Color(hex: "FF6B6B") : Color(hex: "FFB6B6"))
                        .cornerRadius(4)
                    }
                    RuleMark(y: .value("Avg", avgAmount))
                        .foregroundStyle(Color.secondary.opacity(0.3))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                        .annotation(position: .trailing, alignment: .center) {
                            Text("Avg")
                                .font(.proximaNova(size: 10))
                                .foregroundColor(.secondary)
                        }
                }
                .id(timeframe)
                .chartXAxis {
                    if timeframe == .week {
                        AxisMarks(values: .stride(by: .day)) { _ in
                            AxisValueLabel(format: .dateTime.weekday(.narrow))
                                .font(.proximaNova(size: 10))
                        }
                    } else {
                        // Hide X-axis labels for monthly and yearly views
                        AxisMarks { _ in
                            AxisGridLine()
                            AxisTick()
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .trailing, values: .automatic(desiredCount: 3)) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(Color.gray.opacity(0.06))
                        AxisValueLabel {
                            if let amount = value.as(Double.self) {
                                Text("$\(Int(amount))")
                                    .font(.proximaNova(size: 9))
                                    .foregroundStyle(Color.secondary.opacity(0.4))
                            }
                        }
                    }
                }
                .chartYScale(domain: 0...(weeklySpending.map { $0.amount }.max() ?? 100) * 1.1)
                .frame(height: 160)
            }
            
            Divider().padding(.vertical, 4)
            
            // Stats Section
            VStack(spacing: 14) {
                StatRow(title: "Daily avg. spending", value: Formatters.currency(weeklySpending.isEmpty ? 0 : weeklySpending.reduce(0) { $0 + $1.amount } / Double(weeklySpending.count)))
                StatRow(title: "Money in", value: "$0")
                StatRow(title: "Goal contributions", value: "$75")
            }
        }
        .padding(18)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.cardShadow, radius: 10, x: 0, y: 4)
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.proximaNova(size: 13))
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .font(.proximaNova(size: 15, weight: .semibold))
                .foregroundColor(.primary)
        }
    }
}
