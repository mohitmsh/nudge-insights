//
//  ContentView.swift
//  Nudge
//
//  Created by Mohit Sharma on 5/12/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var insightsViewModel = InsightsViewModel()
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            TabView {
                AddPurchaseView(insightsViewModel: insightsViewModel)
                    .tabItem {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                
                InsightsView()
                    .environmentObject(insightsViewModel)
                    .tabItem {
                        Label("Insights", systemImage: "chart.bar.fill")
                    }
                
                TransactionsListView()
                    .environmentObject(insightsViewModel)
                    .tabItem {
                        Label("Transactions", systemImage: "list.bullet.rectangle")
                    }
            }
        }
        .font(.proximaNova(size: 17))
    }
}

#Preview {
    ContentView()
}
