//
//  MyCell.swift
//  BitcoinInfo
//
//  Created by MacBook on 20.05.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import Cartography

class MyCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initailSetUp()
        setUpViews()
        self.selectionStyle = .none
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Properties
    
    lazy var type:UILabel = {
        let label = UILabel()
        label.text = "Sold"
        label.font = UIFont(name: "Helvetica", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var date:UILabel = {
        let label = UILabel()
        label.text = "Date: "
        label.font = UIFont(name: "Helvetica", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var time:UILabel = {
        let label = UILabel()
        label.text = "Time: "
        label.font = UIFont(name: "Helvetica", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateA:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeA:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var view:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var amount:UILabel = {
        let label = UILabel()
        label.text = "Amount"
        label.font = UIFont(name: "Helvetica", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var amountA:UILabel = {
        let label = UILabel()
        label.text = "0.8934232"
        label.font = UIFont(name: "Helvetica", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var id:UILabel = {
        let label = UILabel()
        label.text = "ID: "
        label.font = UIFont(name: "Helvetica", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var idA:UILabel = {
        let label = UILabel()
        label.text = "54534"
        label.font = UIFont(name: "Helvetica", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var price:UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.font = UIFont(name: "Helvetica", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceA:UILabel = {
        let label = UILabel()
        label.text = "8903 BTC"
        label.font = UIFont(name: "Helvetica", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceAll:UILabel = {
        let label = UILabel()
        label.text = "Total amount: "
        label.font = UIFont(name: "Helvetica", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceAllA:UILabel = {
        let label = UILabel()
        label.text = "8903"
        label.font = UIFont(name: "Helvetica", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var clickedView:UIView = {
        let view = UIView()
        view.isHidden  = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: Set up
    func initailSetUp(){
        self.addViews([type,date,time,dateA,timeA,view,clickedView])
        self.clickedView.addViews([price,amount,id,idA,priceA,amountA,priceAll,priceAllA])
    }
    
    //MARK: Set up
    func setUpViews(){
        constrain(type,date,time,dateA,timeA,view,price,priceA,clickedView){type,date,time,dateA,timeA,view,price,priceA,clickedView in
            view.top == view.superview!.top
            view.height == 0.2
            view.width == view.superview!.width
            
            type.centerX == type.superview!.centerX
            type.top == view.bottom + 10
            type.height == 30
            
            date.left == date.superview!.left + self.frame.width*0.1
            date.top == type.bottom + self.frame.height*0.25
            date.height == 20

            dateA.left == date.right + self.frame.width*0.03
            dateA.top == date.top
            dateA.height == 20

            timeA.right == date.superview!.right - self.frame.width*0.1
            timeA.top == date.top
            timeA.height == 20

            time.right == timeA.left - self.frame.width*0.03
            time.top == timeA.top
            time.height == 20
            
            clickedView.top == date.bottom + self.frame.height*0.25
            clickedView.width == clickedView.superview!.width
            
            price.left == date.left
            price.top == clickedView.top
            price.height == 20
            
            priceA.left == price.right + self.frame.width*0.03
            priceA.bottom == price.bottom
            priceA.height == 20
        }
        
        constrain(price,amount,amountA,priceAll,priceAllA,id,idA){priceA,amount,amountA,priceAll,priceAllA,id,idA in
            amount.top == priceA.bottom + self.frame.height*0.25
            amount.left == priceA.left
            amount.height == 20
            
            amountA.left == amount.right + self.frame.width*0.03
            amountA.bottom == amount.bottom
            amountA.height == 20
            
            priceAll.top == amount.bottom + self.frame.height*0.25
            priceAll.left == amount.left
            priceAll.height == 20
            
            priceAllA.left == priceAll.right + self.frame.width*0.03
            priceAllA.bottom == priceAll.bottom
            priceAllA.height == 20
            
            id.top == priceAll.bottom + self.frame.height*0.25
            id.left == priceAll.left
            id.height == 20
            id.bottom == id.superview!.bottom + self.frame.height*0.25
            
            idA.left == id.right + self.frame.width*0.03
            idA.bottom == id.bottom
            idA.height == 20
            idA.bottom == id.superview!.bottom + self.frame.height*0.25
            
        }
    }
}
