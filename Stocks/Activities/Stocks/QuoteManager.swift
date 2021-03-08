//
//  QuoteViewModel.swift
//  Stocks
//
//  Created by Scott on 3/2/21.
//

import SwiftUI

final class QuoteManager: QuoteManagerProtocol, ObservableObject {
    @Published var quotes = [Quote]()
    @Published var mockQuotes = [Quote]()
    
    func download(stocks: [String], completion: @escaping (Result<[Quote], NetworkError>) -> Void) {
        var internalQuotes = [Quote]()
        let downloadQueue = DispatchQueue(label: "com.scott.downloadQueue")
        let downloadGroup = DispatchGroup()
        
        stocks.forEach { (stock) in
            downloadGroup.enter()
            let url = URL(string: API.quoteUrl(for: stock))!
            NetworkManager<GlobalQuote>().fetch(from: url) { (result) in
                switch result {
                case .failure(let error):
                    API.displayError(error, title: "Failed to fetch data")
                    downloadQueue.async {
                        downloadGroup.leave()
                    }
                case .success(let response):
                    downloadQueue.async {
                        internalQuotes.append(response.quote)
                        downloadGroup.leave()
                    }
                }
            }
        }
        downloadGroup.notify(queue: DispatchQueue.global()) {
            completion(.success(internalQuotes))
            DispatchQueue.main.async {
                self.quotes.append(contentsOf: internalQuotes)
            }
        }
    }
    
    func fetchMockQuotes() {
        let quote1 = Quote(symbol: "AAPL", open: "176.55", price: "177.84", previousClose: "178.76", change: "5.23", changePercent: "0.95")
        let quote2 = Quote(symbol: "TSLA", open: "108.84", price: "108.33", previousClose: "105.88", change: "2.22", changePercent: "0.55")
        let quote3 = Quote(symbol: "ELY", open: "78.55", price: "78.55", previousClose: "75.45", change: "1.23", changePercent: "0.75")
        let quote4 = Quote(symbol: "BCRX", open: "30.33", price: "40.55", previousClose: "39.99", change: "0.984", changePercent: "1.34")
        let quote5 = Quote(symbol: "CRSR", open: "200.33", price: "134.55", previousClose: "123.33", change: "3.4", changePercent: "8.54")
        let quote6 = Quote(symbol: "GME", open: "99.99", price: "100.00", previousClose: "99.99", change: ".90", changePercent: "1.23")
        let array = [quote1, quote2, quote3, quote4, quote5, quote6]
        self.mockQuotes = array
    }
    
    func configureNames(symbol: String) -> String {
        var result = symbol
            switch symbol {
            case "TSLA":
                result = "Tesla Inc"
            case "AAPL":
                result = "Apple Inc"
            case "BCRX":
                result = "Biocryst Pharmaceuticals Inc"
            case "CRSR":
                result = "Corsair Gaming Inc"
            case "ELY":
                result = "Callaway Golf Company"
            case "GME":
                result = "Gamestop Corporation"
            default:
                result = ""
            }
        return result
    }
}
