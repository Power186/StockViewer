//
//  SearchViewModel.swift
//  Stocks
//
//  Created by Scott on 3/4/21.
//

import Foundation

final class SearchManager: ObservableObject {
    @Published var searches = [Search]()
    
    func searchStocks(keyword: String) {
        NetworkManager<SearchResponse>().fetch(from: URL(string: API.symbolSearchUrl(for: keyword))!) { (result) in
            switch result {
            case .failure(let error):
                API.displayError(error, title: "Failed to fetch data")
            case .success(let response):
                DispatchQueue.main.async {
                    self.searches = response.bestMatches
                }
            }
        }
    }
    
}
