//
//  Quote.swift
//  Stocks
//
//  Created by Scott on 3/2/21.
//

import Foundation

struct Quote: Codable {
    var symbol: String
    var open: String
    var price: String
    var previousClose: String
    var change: String
    var changePercent: String
    
    enum CodingKeys: String, CodingKey {
        case symbol = "01. symbol"
        case open = "02. open"
        case price = "05. price"
        case previousClose = "08. previous close"
        case change = "09. change"
        case changePercent = "10. change percent"
    }
}

extension Quote: Identifiable {
    var id: UUID {
        return UUID()
    }
}
