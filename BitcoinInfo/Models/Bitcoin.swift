//
//  Bitcoin.swift
//  BitcoinInfo
//
//  Created by MacBook on 18.05.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import Foundation

struct Bitcoin:Decodable{
    let disclaimer:String
    let time:Time
    let bpi:Bpi
}

struct Time: Decodable {
    var updated: String?
    var updatedISO: String?
    var updateduk: String?
    init(_ updated:String,_ updatedISO:String,_ updateduk:String) {
        self.updated = updated
        self.updatedISO = updatedISO
        self.updateduk = updateduk
    }
    init(_ updated:String,_ updatedISO:String) {
        self.updated = updated
        self.updatedISO = updatedISO
    }
}

struct Bpi: Decodable {
    var USD: USD?
    var KZT: KZT?
    var EUR:EUR?
    
    init(usd:USD) {
        self.USD = usd
    }
    
    init(usd:USD,kzt:KZT) {
        self.KZT = kzt
        self.USD = usd
    }
    
    init(usd:USD,eur:EUR) {
        self.EUR = eur
        self.USD = usd
    }
}

struct USD:Decodable {
    let code:String
    let rate:String
    let description:String
    let rate_float:Float
}
struct KZT:Decodable {
    let code:String
    let rate:String
    let description:String
    let rate_float:Float
}
struct EUR:Decodable {
    let code:String
    let rate:String
    let description:String
    let rate_float:Float
}


