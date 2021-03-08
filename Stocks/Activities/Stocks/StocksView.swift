//
//  StocksView.swift
//  Stocks
//
//  Created by Scott on 3/2/21.
//

import SwiftUI

struct StocksView: View {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        return formatter
    }()
    @ObservedObject var quotesVM = QuoteManager()
    @ObservedObject var historicalVM = HistoricalQuoteManager()
    @State private var stocks = ["AAPL", "TSLA", "ELY", "BCRX", "CRSR", "GME"]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(Date(), formatter: dateFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .padding(.leading, 10)
                ScrollView {
                    ForEach(quotesVM.mockQuotes) { quote in
                        HStack {
                            NavigationLink(destination: StockDetailView(quote: quote)) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("\(quote.symbol)")
                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(.primary)
                                    Text("\(quotesVM.configureNames(symbol: quote.symbol))")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }
                                Spacer(minLength: 0)
                                    ChartView(quote: quote)
                                    .frame(width: 150, height: 80)
                                Spacer(minLength: 0)
                                Text(quote.price.currencyFormat())
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(quote.open < quote.previousClose ? .green : .red)
                            }
                        }
                        .padding(10)
                        Divider()
                            .background(Color.secondary)
                    }
                }
            }
            .navigationBarTitle("Stocks")
            .onAppear(perform: {
                quotesVM.fetchMockQuotes()
//                fetchData(for: stocks)
            })
        }
    } // body
    
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

struct StocksView_Previews: PreviewProvider {
    static var previews: some View {
        StocksView()
    }
}
