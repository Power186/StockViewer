//
//  StocksStatsView.swift
//  Stocks
//
//  Created by Scott on 3/7/21.
//

import SwiftUI

struct StockStatsView: View {
    var logs: [Double]
    var priceMax: Int
    
    @Binding var selectedIndex: Int
    
    init(logs: [Double], selectedIndex: Binding<Int>) {
        self._selectedIndex = selectedIndex
        self.logs = logs
        self.priceMax = Int(logs.max(by: { $0 < $1 }) ?? 0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Price")
                        .font(.caption)
                        .foregroundColor(.primary)
                    Text(String(format: "%.2f", logs[selectedIndex]))
                        .font(Font.system(size: 20, weight: .medium, design: .default))
                }
                Color.gray
                    .opacity(0.5)
                    .frame(width: 1, height: 30, alignment: .center)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Rounded Price")
                        .font(.caption)
                        .foregroundColor(.primary)
                    Text(String(format: "%.0f", logs[selectedIndex]))
                        .font(Font.system(size: 20, weight: .medium, design: .default))
                }
                Spacer()
            }
        }
    }
}
