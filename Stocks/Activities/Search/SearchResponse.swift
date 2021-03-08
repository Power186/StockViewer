//
//  SearchResponse.swift
//  Stocks
//
//  Created by Scott on 3/4/21.
//

import Foundation

struct SearchResponse: Codable {
    var bestMatches: [Search]
}

struct Search: Codable, Identifiable {
    var id: UUID { return UUID() }
    var symbol: String
    var name: String
    var type: String
    
    private enum CodingKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
        case type = "3. type"
    }
}
