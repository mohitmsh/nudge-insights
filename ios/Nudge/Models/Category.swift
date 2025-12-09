//
//  Category.swift
//  Nudge
//
//  Created by Mohit Sharma on 6/12/2025.
//

import Foundation
import SwiftUI

enum Category: String, Codable, CaseIterable {
    case eatingOut = "Eating Out"
    case foodDelivery = "Food Delivery"
    case shopping = "Shopping"
    case transport = "Transport"
    case entertainment = "Entertainment"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .eatingOut: return "fork.knife"
        case .foodDelivery: return "bag.fill"
        case .shopping: return "cart.fill"
        case .transport: return "car.fill"
        case .entertainment: return "tv.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .eatingOut: return .orange
        case .foodDelivery: return .red
        case .shopping: return .purple
        case .transport: return .blue
        case .entertainment: return .pink
        case .other: return .gray
        }
    }
}
