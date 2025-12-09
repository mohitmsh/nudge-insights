//
//  InsightHeaderView.swift
//  Nudge
//
//  Created by Mohit Sharma on 6/12/2025.
//

import SwiftUI

struct InsightHeaderView: View {
    let timeframeTitle: String
    let dateRangeText: String
    let selectedTimeframe: InsightsViewModel.Timeframe
    let onTimeframeChange: (InsightsViewModel.Timeframe) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Title and Date Range
            VStack(spacing: 4) {
                Text(timeframeTitle)
                    .font(.proximaNova(size: 28, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(dateRangeText)
                    .font(.proximaNova(size: 13))
                    .foregroundColor(.secondary)
            }
            
            // Timeframe Picker
            HStack(spacing: 12) {
                ForEach(InsightsViewModel.Timeframe.allCases, id: \.self) { timeframe in
                    Button(action: {
                        onTimeframeChange(timeframe)
                    }) {
                        Text(timeframe.rawValue)
                            .font(.proximaNova(size: 14, weight: .semibold))
                            .foregroundColor(selectedTimeframe == timeframe ? .white : .primary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                selectedTimeframe == timeframe ?
                                Color(hex: "FF6B6B") :
                                Color.cardBackground
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .shadow(
                                color: selectedTimeframe == timeframe ?
                                Color(hex: "FF6B6B").opacity(0.3) :
                                Color.cardShadow.opacity(0.3),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.top, 8)
    }
}
