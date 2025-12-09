//
//  NudgeInsight.swift
//  Nudge
//
//  Created by Mohit Sharma on 8/12/2025.
//

import Foundation

struct NudgeInsight: Identifiable, Codable {
    let id = UUID()
    let insight: String
    let tip: String
    
    enum CodingKeys: String, CodingKey {
        case insight, tip
    }
}
