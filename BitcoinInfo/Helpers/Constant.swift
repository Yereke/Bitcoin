//
//  Constant.swift
//  BitcoinInfo
//
//  Created by MacBook on 18.05.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import Foundation

enum UrlPath {
    static let currentPrice = "https://api.coindesk.com/v1/bpi/currentprice.json"
    static let currentPriceKZT = "https://api.coindesk.com/v1/bpi/currentprice/KZT.json"
    static let currentPriceUSD = "https://api.coindesk.com/v1/bpi/currentprice/USD.json"
    static let currentPriceEUR = "https://api.coindesk.com/v1/bpi/currentprice/EUR.json"
    static let transactions = "https://www.bitstamp.net/api/transactions/"
}
