//
//  API.swift
//  BitcoinInfo
//
//  Created by MacBook on 18.05.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import Foundation
import Alamofire

class API{
    
    static let api = API()
    
    private init(){}
    
    public var bitcoin:Bitcoin?
    public var bitcoinInterval:[Bitcoin] = Array()
    public var transactions:[Transaction] = Array()
    
    //MARK: Info Bitcoin
    func fetch(url:String, complition:@escaping ()->()){
        if let gitUrl = URL(string: url){
            URLSession.shared.dataTask(with: gitUrl) { (data, response
                , error) in
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let getData = try decoder.decode(Bitcoin.self, from: data)
                    self.bitcoin = getData
                    complition()
                } catch let err {
                    print("Err", err)
                }
            }.resume()
        }
    }
    
    //MARK: Charts
    func fetchInterval(url:String, complition:@escaping ()->()){
        if let gitUrl = URL(string: url){
            URLSession.shared.dataTask(with: gitUrl) { (data, response
                , error) in
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let getData = try decoder.decode([Bitcoin].self, from: data)
                    self.bitcoinInterval = getData
                    complition()
                } catch let err {
                    print("Err", err)
                }
                }.resume()
        }
    }
    
    //MARK: Transactions
    func fetchTransaction(url:String, complition:@escaping ()->()){
        if let gitUrl = URL(string: url){
            URLSession.shared.dataTask(with: gitUrl) { (data, response
                , error) in
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let getData = try decoder.decode([Transaction].self, from: data)
                    self.transactions = getData
                    complition()
                } catch let err {
                    print("Err", err)
                }
                }.resume()
        }
    }
    
}
