//
//  Purchase.swift
//  Nudge
//
//  Created by Mohit Sharma on 6/12/2025.
//

import SwiftUI

struct Purchase: Codable, Identifiable {
    let id: UUID
    let amount: Double
    let category: Category
    let timestamp: Date
    
    init(id: UUID = UUID(), amount: Double, category: Category, timestamp: Date = Date()) {
        self.id = id
        self.amount = amount
        self.category = category
        self.timestamp = timestamp
    }
}
