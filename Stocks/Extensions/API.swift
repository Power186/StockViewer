//
//  API.swift
//  Stocks
//
//  Created by Scott on 3/4/21.
//

import SwiftUI

struct API {
    static var baseUrl: String {
        return "https://www.alphavantage.co/query?"
    }
    
    static func symbolSearchUrl(for searchKey: String) -> String {
        return urlBy(symbol: .search, searchKey: searchKey)
    }
    
    static func quoteUrl(for searchKey: String) -> String {
        return urlBy(symbol: .quote, searchKey: searchKey)
    }
    
    static func dayQuoteUrl(for searchKey: String) -> String {
        return urlBy(symbol: .daily, searchKey: searchKey)
    }
    
    static func weeklyQuoteUrl(for searchKey: String) -> String {
        return urlBy(symbol: .weekly, searchKey: searchKey)
    }
    
    static func monthlyQuoteUrl(for searchKey: String) -> String {
        return urlBy(symbol: .monthly, searchKey: searchKey)
    }
    
    private static func urlBy(symbol: SymbolFunction, searchKey: String) -> String {
        switch symbol {
        case .search:
            return "\(baseUrl)function=\(symbol.rawValue)&apikey=\(key)&keywords=\(searchKey)"
        case .quote:
            return "\(baseUrl)function=\(symbol.rawValue)&apikey=\(key)&symbol=\(searchKey)"
        case .daily:
            return "\(baseUrl)function=\(symbol.rawValue)&apikey=\(key)&symbol=\(searchKey)"
        case .weekly:
            return "\(baseUrl)function=\(symbol.rawValue)&apikey=\(key)&symbol=\(searchKey)"
        case .monthly:
            return "\(baseUrl)function=\(symbol.rawValue)&apikey=\(key)&symbol=\(searchKey)"
        }
    }
    
    enum SymbolFunction: String {
        case search = "SYMBOL_SEARCH"
        case quote = "GLOBAL_QUOTE"
        case daily = "TIME_SERIES_DAILY"
        case weekly = "TIME_SERIES_WEEKLY"
        case monthly = "TIME_SERIES_MONTHLY"
    }
    
    static func displayError(_ error: Error, title: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
}

extension API {
    static var key: String {
        return "REZOIAIT7A963SSM"
    }
}
