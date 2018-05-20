//
//  Transaction.swift
//  BitcoinInfo
//
//  Created by MacBook on 20.05.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import Foundation

struct Transaction:Decodable{
    let date:String
    let tid:Int
    let price:String
    let type:Int
    let amount:String
}
