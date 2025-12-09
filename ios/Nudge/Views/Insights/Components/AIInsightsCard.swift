//
//  AIInsightsCard.swift
//  Nudge
//
//  Created by Mohit Sharma on 8/12/2025.
//

import SwiftUI

struct AIInsightsCard: View {
    let insights: [NudgeInsight]
    var isLoading: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Image(systemName: "sparkles")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.coral, .coralLight],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("AI Insights")
                    .font(.proximaNovaSemibold(size: 20))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            
            // Insights List
            if isLoading && insights.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Analyzing your spending...")
                            .font(.proximaNova(size: 14))
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.vertical, 20)
                    Spacer()
                }
            } else if insights.isEmpty {
                Text("No insights available yet")
                    .font(.proximaNova(size: 15))
                    .foregroundColor(.textSecondary)
                    .padding(.vertical, 12)
            } else {
                VStack(spacing: 12) {
                    ForEach(insights) { insight in
                        InsightRow(insight: insight)
                    }
                }
                .opacity(isLoading ? 0.5 : 1.0)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        )
    }
}

struct InsightRow: View {
    let insight: NudgeInsight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Insight
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.coral)
                
                Text(insight.insight)
                    .font(.proximaNova(size: 15))
                    .foregroundColor(.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // Tip
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.coralLight.opacity(0.7))
                
                Text(insight.tip)
                    .font(.proximaNova(size: 14))
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.leading, 22)
        }
        .padding(.vertical, 8)
        
        if insight.id != insight.id { // Not the last item
            Divider()
                .background(Color.textSecondary.opacity(0.1))
        }
    }
}

#Preview {
    AIInsightsCard(insights: [
        NudgeInsight(
            insight: "You spend the most on Fridays around 6 PM.",
            tip: "Try preparing dinner earlier on Fridays to avoid ordering food delivery."
        ),
        NudgeInsight(
            insight: "Food delivery accounts for 35% of your spending.",
            tip: "Consider meal prepping on Sundays to reduce delivery orders."
        )
    ])
    .padding()
    .background(Color.appBackground)
}
