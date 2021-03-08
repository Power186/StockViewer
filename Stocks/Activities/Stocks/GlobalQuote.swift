//
//  GlobalQuote.swift
//  Stocks
//
//  Created by Scott on 3/2/21.
//

import Foundation

struct GlobalQuote: Codable {
    var quote: Quote
    
    private enum CodingKeys: String, CodingKey {
        case quote = "Global Quote"
    }
}
