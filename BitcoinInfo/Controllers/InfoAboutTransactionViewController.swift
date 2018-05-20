//
//  InfoAboutTransactionViewController.swift
//  BitcoinInfo
//
//  Created by MacBook on 18.05.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import Cartography

class InfoAboutTransactionViewController: UIViewController {

    //MARK: Properties
    var selectedCellIndexPath: IndexPath?
    let selectedCellHeight: CGFloat  = 200
    let unselectedCellHeight: CGFloat = 80.0
    
    var sold:Int = 0
    var bought:Int = 0
    var Rate:String = ""
    var RateConvert:Double = 0
    
    var transaction:[Transaction] = Array()
    var bitcoin:Bitcoin?
    
    lazy var sellAndBuy:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.968627451, alpha: 1)
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 7
        view.layer.zPosition = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var sell:UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.2509803922, blue: 0.4470588235, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var buy:UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var tableView:UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.register(MyCell.self, forCellReuseIdentifier: "myCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTransaction{
            DispatchQueue.main.async {
                self.sell.setTitle("Sold \(self.sold)", for: .normal)
                self.buy.setTitle("Bouht \(self.transaction.count - self.sold)", for: .normal)
                self.setUpTable()
            }
        }
        initialSetUp()
        SetUp()
    }
    
    // MARK: - Initial set up
    func initialSetUp(){
        self.view.addViews([sellAndBuy])
        self.sellAndBuy.addViews([sell,buy])
    }
    
    // MARK: - Set up constrains
    
    func SetUp(){
        constrain(sellAndBuy,sell,buy){sellAndBuy,sell,buy in
            sellAndBuy.top == sellAndBuy.superview!.top + 64
            sellAndBuy.width == sellAndBuy.superview!.width
            sellAndBuy.height == sellAndBuy.superview!.height*0.08
            
            sell.centerY == sell.superview!.centerY
            sell.left == sell.superview!.left
            sell.height == sell.superview!.height
            sell.width == sell.superview!.width/2
            
            buy.centerY == buy.superview!.centerY
            buy.right == sell.superview!.right
            buy.height == sell.height
            buy.width == sell.width
        }

    }
    
    func setUpTable(){
        self.view.addSubview(tableView)
        constrain(tableView,sellAndBuy){tableView,sellAndBuy in
            tableView.width == tableView.superview!.width
            tableView.top == sellAndBuy.bottom
            tableView.bottom == tableView.superview!.bottom
        }
    }
    
    // MARK: - Fetch transaction
    func fetchTransaction(complition: @escaping () -> Void){
        API.api.fetchTransaction(url: UrlPath.transactions, complition: {self.transaction = API.api.transactions
            self.sold = self.transaction.filter{ $0.type == 0 }.count
            self.updateInformationUSD{
                self.RateConvert = (self.Rate as NSString).doubleValue
            }
            complition()})
    }
    
    func updateInformationUSD(complition: @escaping () -> Void){
        API.api.fetch(url: UrlPath.currentPriceUSD, complition: {self.bitcoin = API.api.bitcoin!;
            self.Rate = (self.bitcoin?.bpi.USD?.rate)!
            complition()})
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension InfoAboutTransactionViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyCell
        cell.backgroundColor = #colorLiteral(red: 0.9311900139, green: 0.9626160264, blue: 0.9387993217, alpha: 1)
        DispatchQueue.main.async {
            cell.amountA.text = self.transaction[indexPath.row].amount
            cell.idA.text = String(self.transaction[indexPath.row].tid)
            cell.priceA.text = self.transaction[indexPath.row].price
            let total = Double("\(self.transaction[indexPath.row].amount)")! * Double("\(self.transaction[indexPath.row].price)")! * self.RateConvert
            cell.priceAllA.text = String("\(total) $")
            
            let date = Date.init(timeIntervalSince1970: TimeInterval(Double(self.transaction[indexPath.row].date)!))
            let dateFormatter = DateFormatter()
            let timeFormatter = DateFormatter()
            
            let theDateFormat = DateFormatter.Style.short
            let theTimeFormat = DateFormatter.Style.short
            
            dateFormatter.dateStyle = theDateFormat
            timeFormatter.timeStyle = theTimeFormat
            
            let dateFormat = dateFormatter.string(from: date);
            let timeFormat = timeFormatter.string(from: date);
            
            cell.dateA.text = dateFormat
            cell.timeA.text = timeFormat
        }
        
        if self.transaction[indexPath.row].type == 0{
            cell.type.text = "Bought"
        }else{
            cell.type.text = "Sold"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedCellIndexPath == indexPath {
            return selectedCellHeight
        }
        return unselectedCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath {
            selectedCellIndexPath = nil
             (self.tableView.visibleCells[(indexPath.row)] as! MyCell).clickedView.isHidden = true
        } else {
            selectedCellIndexPath = indexPath
            for cell in self.tableView.visibleCells{
                (cell as! MyCell).clickedView.isHidden = true
            }
            (self.tableView.visibleCells[indexPath.row] as! MyCell).clickedView.isHidden = false
        }
        tableView.beginUpdates()
        tableView.endUpdates()
        if selectedCellIndexPath != nil {
            tableView.scrollToRow(at: indexPath as IndexPath, at: .none, animated: true)
        }
    }
}
