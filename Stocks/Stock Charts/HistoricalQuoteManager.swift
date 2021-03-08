//
//  DailyQuoteManager.swift
//  Stocks
//
//  Created by Scott on 3/7/21.
//

import SwiftUI

final class HistoricalQuoteManager: ObservableObject {
    @Published var dailyStockPrices = [Double]()
    @Published var weeklyStockPrices = [Double]()
    @Published var monthlyStockPrices = [Double]()
    
    func downloadDailyStocks(stock: String, completion: @escaping (Result<StocksDaily, NetworkError>) -> Void) {
        let url = URL(string: API.dayQuoteUrl(for: stock))!
        NetworkManager<StocksDaily>().fetch(from: url) { (result) in
            switch result {
            case .success(let stockData):
                guard let stockData = stockData.timeSeriesDaily else { return }
                for (_, value) in stockData {
                    let stockDouble = Double(value.close) ?? 0.0
                    DispatchQueue.main.async {
                        self.dailyStockPrices.append(stockDouble)
                    }
                }
            case .failure(let error):
                API.displayError(error, title: "Failed to fetch daily data")
            }
        }
    }
    
    func downloadWeeklyStocks(stock: String, completion: @escaping (Result<StocksWeekly, NetworkError>) -> Void) {
        let url = URL(string: API.weeklyQuoteUrl(for: stock))!
        NetworkManager<StocksWeekly>().fetch(from: url) { (result) in
            switch result {
            case .success(let stockData):
                guard let stockData = stockData.timeSeriesWeekly else { return }
                for (_, value) in stockData {
                    let stockDouble = Double(value.close) ?? 0.0
                    DispatchQueue.main.async {
                        self.weeklyStockPrices.append(stockDouble)
                    }
                }
            case .failure(let error):
                API.displayError(error, title: "Failed to fetch weekly data")
            }
        }
    }
    
    func downloadMonthlyStocks(stock: String, completion: @escaping (Result<StocksMonthly, NetworkError>) -> Void) {
        let url = URL(string: API.monthlyQuoteUrl(for: stock))!
        NetworkManager<StocksMonthly>().fetch(from: url) { (result) in
            switch result {
            case .success(let stockData):
                guard let stockData = stockData.timeSeriesMonthly else { return }
                for (_, value) in stockData {
                    let stockDouble = Double(value.close) ?? 0.0
                    DispatchQueue.main.async {
                        self.monthlyStockPrices.append(stockDouble)
                    }
                }
            case .failure(let error):
                API.displayError(error, title: "Failed to fetch monthly data")
            }
        }
    }
    
}
