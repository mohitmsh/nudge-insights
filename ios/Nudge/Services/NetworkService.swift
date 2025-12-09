//
//  NetworkService.swift
//  Nudge
//
//  Handles all API communication with the backend server
//  - Fetches transactions
//  - Saves new purchases
//  - Retrieves AI-generated insights
//

import Foundation

// MARK: - Network Errors

/// Custom errors for network operations
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError
    case decodingError
    case encodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid server response"
        case .serverError: return "Server error occurred"
        case .decodingError: return "Failed to decode response"
        case .encodingError: return "Failed to encode request"
        }
    }
}

// MARK: - Network Service

class NetworkService {
    static let shared = NetworkService()
    
    // MARK: - Constants
    
    /// Base URL for API - Update this for production
    private let baseURL = "http://localhost:5001"
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    private init() {}
    
    // MARK: - API Models
    struct TransactionRequest: Codable {
        let amount: Double
        let category: String
        let timestamp: String
    }
    
    struct TransactionResponse: Codable {
        let id: String
        let amount: Double
        let category: String
        let timestamp: String
    }
    
    struct InsightResponse: Codable {
        let insights: [Insight]
    }
    
    struct Insight: Codable {
        let insight: String
        let tip: String
    }
    
    // MARK: - API Methods
    func fetchPurchases() async throws -> [Purchase] {
        guard let url = URL(string: "\(baseURL)/transactions") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.serverError
        }
        
        let transactions = try JSONDecoder().decode([TransactionResponse].self, from: data)
        return transactions.map { $0.toPurchase() }
    }
    
    func savePurchase(_ purchase: Purchase) async throws {
        guard let url = URL(string: "\(baseURL)/transactions") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Format timestamp as ISO8601 string
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let timestampString = dateFormatter.string(from: purchase.timestamp)
        
        let transactionRequest = TransactionRequest(
            amount: purchase.amount,
            category: purchase.category.rawValue,
            timestamp: timestampString
        )
        
        request.httpBody = try JSONEncoder().encode(transactionRequest)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 201 else {
            throw NetworkError.serverError
        }
    }
    
    func fetchInsights(timeframe: String = "week") async throws -> [NudgeInsight] {
        guard var urlComponents = URLComponents(string: "\(baseURL)/insights") else {
            throw NetworkError.invalidURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "timeframe", value: timeframe)
        ]
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.serverError
        }
        
        let insightResponse = try JSONDecoder().decode(InsightResponse.self, from: data)
        return insightResponse.insights.map { NudgeInsight(insight: $0.insight, tip: $0.tip) }
    }
}

// MARK: - Extensions
extension NetworkService.TransactionResponse {
    func toPurchase() -> Purchase {
        // Try multiple date formats to parse the timestamp
        let date: Date
        
        // Format 1: ISO8601 with fractional seconds (2025-05-02T18:12:44)
        let formatter1 = ISO8601DateFormatter()
        formatter1.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Format 2: ISO8601 without fractional seconds
        let formatter2 = ISO8601DateFormatter()
        formatter2.formatOptions = [.withInternetDateTime]
        
        // Format 3: Custom format matching backend
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter3.locale = Locale(identifier: "en_US_POSIX")
        formatter3.timeZone = TimeZone.current
        
        if let parsedDate = formatter1.date(from: timestamp) {
            date = parsedDate
        } else if let parsedDate = formatter2.date(from: timestamp) {
            date = parsedDate
        } else if let parsedDate = formatter3.date(from: timestamp) {
            date = parsedDate
        } else {
            print("Failed to parse timestamp: \(timestamp)")
            date = Date() // Fallback to now
        }
        
        return Purchase(
            id: UUID(),
            amount: amount,
            category: Category(rawValue: category) ?? .other,
            timestamp: date
        )
    }
}
