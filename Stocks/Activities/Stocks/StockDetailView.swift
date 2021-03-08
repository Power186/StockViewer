//
//  StockDetailView.swift
//  Stocks
//
//  Created by Scott on 3/3/21.
//

import SwiftUI

struct StockDetailView: View {
    @ObservedObject var quotesVM = QuoteManager()
    @ObservedObject var historicalVM = HistoricalQuoteManager()
    let quote: Quote
    @State private var dailySelectedIndex = 0
    @State private var weeklySelectedIndex = 0
    @State private var monthlySelectedIndex = 0
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var dailyPriceArray = [Double]()
    @State private var weeklyPriceArray = [Double]()
    @State private var monthlyPriceArray = [Double]()
    
    var body: some View {
        ScrollView {
            HeaderView()
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(quote.symbol)")
                        .font(.caption)
                        .bold()
                        .padding(.bottom, 12)
                    Text("\(quotesVM.configureNames(symbol: quote.symbol))")
                        .font(.title)
                        .bold()
                    Text(quote.price.currencyFormat())
                        .font(.title2)
                        .bold()
                    HStack {
                        Image(systemName: quote.open < quote.previousClose ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                            .imageScale(.small)
                        Text(quote.change)
                            .font(.caption)
                            .bold()
                    }
                    .foregroundColor(quote.open < quote.previousClose ? .green : .red)
                    .padding(.top, 12)
                }
                Spacer()
            }
            .padding(.top, 12)
            .padding(.leading, 12)
            .navigationBarHidden(true)
            .onAppear(perform: {
//                fetchDailyData(for: quote.symbol)
//                    fetchWeeklyData(for: quote.symbol)
//                    fetchMontlyData(for: quote.symbol)
                dailyPriceArray = historicalVM.dailyStockPrices
                weeklyPriceArray = historicalVM.weeklyStockPrices
                monthlyPriceArray = historicalVM.monthlyStockPrices
            })
            
            // Chart here
            VStack(spacing: 20) {
                if dailyPriceArray.isEmpty {
                    Button(action: {
                        fetchDailyData(for: quote.symbol)
                        dailyPriceArray = historicalVM.dailyStockPrices
                        weeklyPriceArray = historicalVM.weeklyStockPrices
                        monthlyPriceArray = historicalVM.monthlyStockPrices
                    }) {
                        Text("Reveal chart data")
                            .font(.headline)
                    }.buttonStyle(ColoredButtonStyle(color: Color.green))
                    .animation(.easeOut(duration: 2.0))
                    
                } else {
                    ScrollView(.vertical) {
                        VStack(alignment: .center) {
                            StockStatsView(logs: dailyPriceArray, selectedIndex: $dailySelectedIndex)
                            StockGraphView(logs: dailyPriceArray, selectedIndex: $dailySelectedIndex)
                            Text("Daily")
                                .font(.headline)
                        }
                        VStack(alignment: .center) {
//                            StockStatsView(logs: weeklyPriceArray, selectedIndex: $weeklySelectedIndex)
//                            StockGraphView(logs: weeklyPriceArray, selectedIndex: $weeklySelectedIndex)
//                            Text("Weekly")
//                                .font(.headline)
                        }
                        VStack(alignment: .center) {
//                            StockStatsView(logs: monthlyPriceArray, selectedIndex: $monthlySelectedIndex)
//                            StockGraphView(logs: monthlyPriceArray, selectedIndex: $monthlySelectedIndex)
//                            Text("Monthly")
//                                .font(.headline)
                        }
                    }
                    .padding(.bottom, 10)
                }
            }
            .padding(.top, 50)
        }
    }
    
    private func fetchDailyData(for symbol: String) {
        historicalVM.downloadDailyStocks(stock: symbol) { _ in
            // completion block
        }
    }
    
    private func fetchWeeklyData(for symbol: String) {
        historicalVM.downloadWeeklyStocks(stock: symbol) { _ in
            // completion block
        }
    }
    
    private func fetchMontlyData(for symbol: String) {
        historicalVM.downloadMonthlyStocks(stock: symbol) { _ in
            // completion block
        }
    }
    
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StockDetailView(quote: Quote(symbol: "AAPL", open: "176.55", price: "177.84", previousClose: "178.76", change: "5.23", changePercent: "0.95"))
    }
}


