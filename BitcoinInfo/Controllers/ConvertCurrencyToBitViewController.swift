//
//  ConvertcCurrencyToBitViewController.swift
//  BitcoinInfo
//
//  Created by MacBook on 18.05.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import Cartography

class ConvertCurrencyToBitViewController: UIViewController {

    // MARK: - Properties
    var bitcoin:Bitcoin?
    
    var Rate:String = ""
    var RateConvert:Double = 0
    var segment:Int = 0

    lazy var segmentedControl:UISegmentedControl = {
        let item = ["USD", "EUR", "KZT"]
        let segment = UISegmentedControl(items: item)
        segment.selectedSegmentIndex = 0
        segment.layer.cornerRadius = 7
        segment.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.2509803922, blue: 0.4470588235, alpha: 1)
        segment.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        segment.layer.borderWidth = 1
        segment.layer.borderColor = #colorLiteral(red: 0.1098039216, green: 0.2509803922, blue: 0.4470588235, alpha: 1)
        segment.addTarget(self, action: #selector(changeCourse), for: .valueChanged)
        return segment
    }()
    
    lazy var FromMoneyToBTC:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var BTC:UILabel = {
        let label = UILabel()
        label.text = "BTC->$:"
        label.textColor = #colorLiteral(red: 0.1098039216, green: 0.2509803922, blue: 0.4470588235, alpha: 1)
        label.font = UIFont(name: "Helvetica-Bold", size: self.view.frame.width*0.05)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var BTCTextField:UITextField = {
        let text = UITextField()
        text.placeholder = "BTC"
        text.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        text.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        text.keyboardType = .decimalPad
        text.layer.borderWidth = 1
        text.layer.cornerRadius = 4
        text.layer.sublayerTransform = CATransform3DMakeTranslation(10, 2, 0)
        text.font = UIFont(name: "Helvetica", size: 17)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var Money:UILabel = {
        let label = UILabel()
        label.text = "USD->฿:"
        label.textColor = #colorLiteral(red: 0.1098039216, green: 0.2509803922, blue: 0.4470588235, alpha: 1)
        label.font = UIFont(name: "Helvetica-Bold", size: self.view.frame.width*0.05)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var MoneyTextField:UITextField = {
        let text = UITextField()
        text.placeholder = "1000"
        text.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        text.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        text.layer.borderWidth = 1
        text.layer.cornerRadius = 4
        text.keyboardType = .decimalPad
        text.layer.sublayerTransform = CATransform3DMakeTranslation(10, 2, 0)
        text.font = UIFont(name: "Helvetica", size: 17)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var convertButton:UIButton = {
        let button = UIButton()
        button.setTitle("Convert", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.2509803922, blue: 0.4470588235, alpha: 1)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(covertButton), for: .touchUpInside)
        return button
    }()
    
    lazy var result:UILabel = {
        let label = UILabel()
        label.text = "Result"
        label.textColor = #colorLiteral(red: 0.1098039216, green: 0.2509803922, blue: 0.4470588235, alpha: 1)
        label.font = UIFont(name: "Helvetica", size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        setUp()
        updateInformationUSD{self.RateConvert = (self.Rate as NSString).doubleValue}
    }
    
    // MARK: - Initial set up
    func initialSetUp(){
        self.view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.968627451, alpha: 1)
        self.navigationItem.title = "Converter"
        self.view.addViews([segmentedControl,FromMoneyToBTC])
        self.FromMoneyToBTC.addViews([BTC,Money,BTCTextField,MoneyTextField,convertButton,result])
    }
    
    // MARK: - Set up constrains
    func setUp(){
        constrain(segmentedControl,FromMoneyToBTC){segmentedControl,FromMoneyToBTC in
            segmentedControl.top == segmentedControl.superview!.top + 64
            segmentedControl.width == segmentedControl.superview!.width - self.view.frame.width*0.04
            segmentedControl.height == segmentedControl.superview!.height*0.066
            segmentedControl.centerX == segmentedControl.superview!.centerX
            
            FromMoneyToBTC.top == segmentedControl.bottom + 10
            FromMoneyToBTC.width == segmentedControl.width
            FromMoneyToBTC.height == FromMoneyToBTC.superview!.height*0.4
            FromMoneyToBTC.centerX == FromMoneyToBTC.superview!.centerX
        }
        constrain(BTC,Money,BTCTextField,MoneyTextField,convertButton,result){BTC,Money,BTCTextField,MoneyTextField,convertButton,result in
            BTC.top == BTC.superview!.top + self.view.frame.height*0.025
            BTC.left == BTC.superview!.left + 8
            
            BTCTextField.top == BTC.superview!.top + self.view.frame.height*0.021
            BTCTextField.left == BTC.right
            BTCTextField.right == BTC.superview!.right - 8
            BTCTextField.width == BTCTextField.superview!.width - self.view.frame.width*0.26
            BTCTextField.height == BTCTextField.superview!.height*0.12
            
            Money.top == BTCTextField.bottom + self.view.frame.height*0.025
            Money.left == BTC.left
            
            MoneyTextField.top == BTCTextField.bottom + self.view.frame.height*0.021
            MoneyTextField.left == Money.right
            MoneyTextField.right == BTCTextField.right
            MoneyTextField.width == BTCTextField.width
            MoneyTextField.height == BTCTextField.height
            
            convertButton.bottom == convertButton.superview!.bottom - 10
            convertButton.height == convertButton.superview!.height*0.2
            convertButton.width == convertButton.superview!.width*0.7
            convertButton.centerX == convertButton.superview!.centerX
            
            result.center == result.superview!.center
        }
    }
    
    // MARK: - KeyBoard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Segment select
    @objc func changeCourse(){
        let courseBTC:[String] = ["BTC->$","BTC->€","BTC->₸"]
        let courseMoney:[String] = ["USD->฿","EUR->฿","KZT->฿"]
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.segment = 0
            BTC.text = courseBTC[segment]
            Money.text = courseMoney[segment]
            API.api.fetch(url: UrlPath.currentPriceUSD, complition: {self.bitcoin = API.api.bitcoin!})
            updateInformationUSD{self.RateConvert = (self.Rate as NSString).doubleValue}
        case 1:
            self.segment = 1
            BTC.text = courseBTC[segment]
            Money.text = courseMoney[segment]
            API.api.fetch(url: UrlPath.currentPriceEUR, complition: {self.bitcoin = API.api.bitcoin!})
            updateInformationEUR{self.RateConvert = (self.Rate as NSString).doubleValue}
        default:
            self.segment = 2
            BTC.text = courseBTC[segment]
            Money.text = courseMoney[segment]
            API.api.fetch(url: UrlPath.currentPriceKZT, complition: {self.bitcoin = API.api.bitcoin!})
            updateInformationKZT{self.RateConvert = (self.Rate as NSString).doubleValue}
        }
    }
    
    @objc func covertButton(){
        let cource:[String] = [" $"," €"," ₸"]
        if MoneyTextField.text!.count > 0{
            self.RateConvert = (self.Rate as NSString).doubleValue
            let money = (MoneyTextField.text! as NSString).doubleValue
            result.text = String((money/RateConvert)) + " BCT"
        }
        if BTCTextField.text!.count > 0{
            self.RateConvert = (self.Rate as NSString).doubleValue
            let money = (BTCTextField.text! as NSString).doubleValue
            print(RateConvert)
            result.text = String(money*RateConvert) + cource[segment]
        }
        if (BTCTextField.text!.count == 0 && MoneyTextField.text!.count == 0){
            result.text = "Nothing to convert"
        }
    }
    
    // MARK: - Fetch
    func updateInformationUSD(complition: @escaping () -> Void){
        API.api.fetch(url: UrlPath.currentPriceUSD, complition: {self.bitcoin = API.api.bitcoin!;
            self.Rate = (self.bitcoin?.bpi.USD?.rate)!
            complition()})
    }
    func updateInformationEUR(complition: @escaping () -> Void){
        API.api.fetch(url: UrlPath.currentPriceEUR, complition: {self.bitcoin = API.api.bitcoin!;
            self.Rate = (self.bitcoin?.bpi.EUR?.rate)!
            complition()})
    }
    func updateInformationKZT(complition: @escaping () -> Void){
        API.api.fetch(url: UrlPath.currentPriceKZT, complition: {self.bitcoin = API.api.bitcoin!;
            self.Rate = (self.bitcoin?.bpi.KZT?.rate)!
            complition()})
    }
}
