//
//  DateSection.swift
//  Nudge
//
//  Created by Mohit Sharma on 6/12/2025.
//

import SwiftUI

struct DateSection: View {
    @Binding var useCustomDate: Bool
    @Binding var customDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Date & Time")
                .font(.proximaNova(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .tracking(1.2)
            
            VStack(spacing: 16) {
                Toggle(isOn: $useCustomDate.animation(.spring(response: 0.35))) {
                    HStack(spacing: 12) {
                        Image(systemName: useCustomDate ? "calendar.circle.fill" : "clock.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(useCustomDate ? .blue : .secondary)
                        
                        Text(useCustomDate ? "Custom Date" : "Use Custom Date")
                            .font(.proximaNova(size: 16))
                            .foregroundColor(.primary)
                    }
                }
                .tint(.blue)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.cardBackground)
                        .shadow(color: Color.cardShadow, radius: 12, x: 0, y: 6)
                )
                
                if useCustomDate {
                    DatePicker(
                        "Select Date",
                        selection: $customDate,
                        in: ...Date(),
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.graphical)
                    .tint(.blue)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.cardBackground)
                            .shadow(color: Color.cardShadow, radius: 12, x: 0, y: 6)
                    )
                    .transition(.scale.combined(with: .opacity))
                } else {
                    HStack(spacing: 12) {
                        Image(systemName: "clock.badge.checkmark.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.green)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Right Now")
                                .font(.proximaNova(size: 15, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text(Date(), formatter: dateFormatter)
                                .font(.proximaNova(size: 13))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.cardBackground)
                            .shadow(color: Color.cardShadow, radius: 12, x: 0, y: 6)
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}
