//
//  QuoteManagerProtocol.swift
//  Stocks
//
//  Created by Scott on 3/4/21.
//

import Foundation

protocol QuoteManagerProtocol {
    var quotes: [Quote] { get set }
    func download(stocks: [String], completion: @escaping (Result<[Quote], NetworkError>) -> Void)
}

