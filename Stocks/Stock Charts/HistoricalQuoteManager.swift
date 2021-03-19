//
//  DailyQuoteManager.swift
//  Stocks
//
//  Created by Scott on 3/7/21.
//

import SwiftUI
import CoreData

final class HistoricalQuoteManager: ObservableObject {
    @Published var dailyStockPrices = [Double]()
    @Published var weeklyStockPrices = [Double]()
    @Published var monthlyStockPrices = [Double]()
    @Environment(\.managedObjectContext) var managedObjectContext
    
    func fetchDailyStocks(stock: String, completion: @escaping (Result<StocksDaily, NetworkError>) -> Void) {
        guard let url = URL(string: API.dayQuoteUrl(for: stock)) else { return }
        
        let dailyData = HistoricalStockPrice(context: managedObjectContext)
        if let dataArray = dailyData.dailyPrice {
            if dataArray.isEmpty {
                
                NetworkManager<StocksDaily>().fetch(from: url) { [weak self] (result) in
                    switch result {
                    case .success(let stockData):
                        guard let stockData = stockData.timeSeriesDaily else { return }
                        for (_, value) in stockData {
                            let stockDouble = Double(value.close) ?? 0.0
                            DispatchQueue.main.async {
                                dailyData.dailyPrice?.append(stockDouble)
                                self?.dailyStockPrices.append(contentsOf: dataArray)
                                PersistenceController.shared.save()
                            }
                        }
                    case .failure(let error):
                        API.displayError(error, title: "Failed to fetch daily data")
                    }
                }
            }
        }
    }
    
    func fetchWeeklyStocks(stock: String, completion: @escaping (Result<StocksWeekly, NetworkError>) -> Void) {
        guard let url = URL(string: API.weeklyQuoteUrl(for: stock)) else { return }
        
        let weeklyData = HistoricalStockPrice(context: managedObjectContext)
        if let dataArray = weeklyData.weeklyPrice {
            if dataArray.isEmpty {
                
                NetworkManager<StocksWeekly>().fetch(from: url) { [weak self] (result) in
                    switch result {
                    case .success(let stockData):
                        guard let stockData = stockData.timeSeriesWeekly else { return }
                        for (_, value) in stockData {
                            let stockDouble = Double(value.close) ?? 0.0
                            DispatchQueue.main.async {
                                weeklyData.weeklyPrice?.append(stockDouble)
                                self?.weeklyStockPrices.append(contentsOf: dataArray)
                                PersistenceController.shared.save()
                            }
                        }
                    case .failure(let error):
                        API.displayError(error, title: "Failed to fetch daily data")
                    }
                }
            }
        }
    }
    
    func fetchMonthlyStocks(stock: String, completion: @escaping (Result<StocksMonthly, NetworkError>) -> Void) {
        guard let url = URL(string: API.monthlyQuoteUrl(for: stock)) else { return }
        
        let monthlyData = HistoricalStockPrice(context: managedObjectContext)
        if let dataArray = monthlyData.monthlyPrice {
            if dataArray.isEmpty {
                
                NetworkManager<StocksMonthly>().fetch(from: url) { [weak self] (result) in
                    switch result {
                    case .success(let stockData):
                        guard let stockData = stockData.timeSeriesMonthly else { return }
                        for (_, value) in stockData {
                            let stockDouble = Double(value.close) ?? 0.0
                            DispatchQueue.main.async {
                                monthlyData.monthlyPrice?.append(stockDouble)
                                self?.monthlyStockPrices.append(contentsOf: dataArray)
                                PersistenceController.shared.save()
                            }
                        }
                    case .failure(let error):
                        API.displayError(error, title: "Failed to fetch daily data")
                    }
                }
            }
        }
    }
    
}
