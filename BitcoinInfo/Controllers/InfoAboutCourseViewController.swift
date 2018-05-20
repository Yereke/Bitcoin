//
//  InfoAboutCourseViewController.swift
//  BitcoinInfo
//
//  Created by MacBook on 18.05.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import Cartography
import SwiftCharts
import Charts
import Alamofire

class InfoAboutCourseViewController: UIViewController,UIScrollViewDelegate {
    
    // MARK: - Properties
    var bitcoin:Bitcoin?
    var bitcoinInterval:[Bitcoin] = Array()
    var intervalPrice:[Double] = Array()
    var segment:Int = 0
    var segmentCourse:String = "USD"
    
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
    
    lazy var segmentedControlToInterval:UISegmentedControl = {
        let item = ["Week", "Month", "Year"]
        let segment = UISegmentedControl(items: item)
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        let segAttributes: NSDictionary = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
        NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 20)!
        ]
        segment.setTitleTextAttributes(segAttributes as [NSObject : AnyObject], for: UIControlState.selected)
        segment.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        segment.layer.borderWidth = 1
        segment.addTarget(self, action: #selector(changeInterval), for: .valueChanged)
        return segment
    }()
    
    lazy var chrChart:LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    lazy var InfoViewAboutCourse:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var course:UILabel = {
        let label = UILabel()
        label.text = "Course"
        label.font = UIFont(name: "Helvetica", size: self.view.frame.width*0.04)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var rate:UILabel = {
        let label = UILabel()
        label.text = "Rate"
        label.font = UIFont(name: "Helvetica", size: self.view.frame.width*0.04)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionL:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: self.view.frame.width*0.04)
        label.text = "Description"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var updated:UILabel = {
        let label = UILabel()
        label.text = "Last updated"
        label.font = UIFont(name: "Helvetica", size: self.view.frame.width*0.04)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var courseA:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: self.view.frame.width*0.04)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var rateA:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: self.view.frame.width*0.04)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLA:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: self.view.frame.width*0.04)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var updatedA:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: self.view.frame.width*0.04)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var scrollView:UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height - 64)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateInterval = Calendar.current.date(byAdding: .day, value: -8, to: Date())
        let date = getDate(dateInterval!)
        fetchPriceInterval(date){
            self.upDateChart()
        }
        initialSetUp()
        setUpConstrains()
        updateInformationUSD{
            DispatchQueue.main.async {
                self.courseA.text = self.bitcoin?.bpi.USD?.code
                self.descriptionLA.text = self.bitcoin?.bpi.USD?.description
                self.rateA.text = self.bitcoin?.bpi.USD?.rate
                self.updatedA.text = self.bitcoin?.time.updated
            }
        }
    }
    
    // MARK: - Initial set up
    func initialSetUp(){
        self.view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.968627451, alpha: 1)
        self.navigationItem.title = "Course"
        self.view.addSubview(scrollView)
        self.scrollView.addViews([segmentedControl,chrChart,InfoViewAboutCourse,segmentedControlToInterval])
        self.InfoViewAboutCourse.addViews([course,descriptionL,rate,updated,courseA,descriptionLA,rateA,updatedA])
    }
    
    func updateInformationUSD(complition: @escaping () -> Void){
        API.api.fetch(url: UrlPath.currentPriceUSD, complition: {self.bitcoin = API.api.bitcoin!;
            complition()})
    }
    func updateInformationEUR(complition: @escaping () -> Void){
        API.api.fetch(url: UrlPath.currentPriceEUR, complition: {self.bitcoin = API.api.bitcoin!; complition()})
    }
    func updateInformationKZT(complition: @escaping () -> Void){
        API.api.fetch(url: UrlPath.currentPriceKZT, complition: {self.bitcoin = API.api.bitcoin!; complition()})
    }
    
    // MARK: - Set up constrains
    func setUpConstrains(){
        constrain(scrollView){scrollView in
            scrollView.width == scrollView.superview!.width
            scrollView.height == scrollView.superview!.height
        }
        
        constrain(segmentedControl,chrChart,InfoViewAboutCourse,segmentedControlToInterval){segmentedControl,chrChart,InfoViewAboutCourse,segmentedControlToInterval in
            
            segmentedControl.top == segmentedControl.superview!.top
            segmentedControl.width == segmentedControl.superview!.width - self.view.frame.width*0.05
            segmentedControl.height == segmentedControl.superview!.height*0.066
            segmentedControl.centerX == segmentedControl.superview!.centerX
            
            InfoViewAboutCourse.top == segmentedControl.bottom + self.view.frame.height*0.04
            InfoViewAboutCourse.width == InfoViewAboutCourse.superview!.width - self.view.frame.width*0.05
            InfoViewAboutCourse.height == InfoViewAboutCourse.superview!.height*0.18
            InfoViewAboutCourse.centerX == InfoViewAboutCourse.superview!.centerX
            
            segmentedControlToInterval.top == InfoViewAboutCourse.bottom + self.view.frame.height*0.04
            segmentedControlToInterval.width == InfoViewAboutCourse.width
            segmentedControlToInterval.height == segmentedControl.height
            segmentedControlToInterval.centerX == segmentedControl.superview!.centerX
            
            chrChart.width == chrChart.superview!.width
            chrChart.height == chrChart.superview!.height*0.5
            chrChart.top == segmentedControlToInterval.bottom + self.view.frame.height*0.04
        }
        
        constrain(course,descriptionL,rate,updated,courseA,descriptionLA,rateA,updatedA){course,descriptionL,rate,updated,courseA,descriptionLA,rateA,updatedA in
            descriptionL.top == descriptionL.superview!.top + self.view.frame.height*0.01
            descriptionL.left == descriptionL.superview!.left + 5
            
            course.top == descriptionL.bottom + self.view.frame.height*0.01
            course.left == descriptionL.left
            
            rate.top == course.bottom + self.view.frame.height*0.01
            rate.left == course.left
            
            updated.top == rate.bottom + self.view.frame.height*0.01
            updated.left == course.left
            updated.bottom == updated.superview!.bottom - self.view.frame.height*0.01
            
            // MARK : Answers
            descriptionLA.top == descriptionL.top + 2
            descriptionLA.left == updated.right + self.view.frame.width*0.1
            
            courseA.top == course.top
            courseA.left == descriptionLA.left
            
            rateA.top == rate.top
            rateA.left == courseA.left
            
            updatedA.top == updated.top
            updatedA.left == rateA.left
        }
    }
    
    // MARK: - Segment select
    @objc func changeCourse(){
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            segmentCourse = "USD"
            API.api.fetch(url: UrlPath.currentPriceUSD, complition: {self.bitcoin = API.api.bitcoin!})
            intervalPrice.removeAll()
            let dateInterval = Calendar.current.date(byAdding: .day, value: -8, to: Date())
            let date = getDate(dateInterval!)
            fetchPriceInterval(date){
                self.upDateChart()
            }
            updateInformationUSD{
                DispatchQueue.main.async {
                    self.courseA.text = self.bitcoin?.bpi.USD?.code
                    self.descriptionLA.text = self.bitcoin?.bpi.USD?.description
                    self.rateA.text = self.bitcoin?.bpi.USD?.rate
                    self.updatedA.text = self.bitcoin?.time.updated
                }
            }
        case 1:
            segmentCourse = "EUR"
            API.api.fetch(url: UrlPath.currentPriceEUR, complition: {self.bitcoin = API.api.bitcoin!})
            intervalPrice.removeAll()
            let dateInterval = Calendar.current.date(byAdding: .month, value: -1, to: Date())
            let date = getDate(dateInterval!)
            fetchPriceInterval(date){
                self.upDateChart()
            }
            updateInformationEUR{
                DispatchQueue.main.async {
                    self.courseA.text = self.bitcoin?.bpi.EUR?.code
                    self.descriptionLA.text = self.bitcoin?.bpi.EUR?.description
                    self.rateA.text = self.bitcoin?.bpi.EUR?.rate
                    self.updatedA.text = self.bitcoin?.time.updated
                }
            }
        default:
            segmentCourse = "KZT"
            API.api.fetch(url: UrlPath.currentPriceKZT, complition: {self.bitcoin = API.api.bitcoin!})
            intervalPrice.removeAll()
            let dateInterval = Calendar.current.date(byAdding: .year, value: -1, to: Date())
            let date = getDate(dateInterval!)
            fetchPriceInterval(date){
                self.upDateChart()
            }
            updateInformationKZT{
                DispatchQueue.main.async {
                    self.courseA.text = self.bitcoin?.bpi.KZT?.code
                    self.descriptionLA.text = self.bitcoin?.bpi.KZT?.description
                    self.rateA.text = self.bitcoin?.bpi.KZT?.rate
                    self.updatedA.text = self.bitcoin?.time.updated
                }
            }
        }
    }
    
    @objc func changeInterval(){
        switch segmentedControlToInterval.selectedSegmentIndex {
        case 0:
            segment = 0
            intervalPrice.removeAll()
            let dateInterval = Calendar.current.date(byAdding: .day, value: -8, to: Date())
            let date = getDate(dateInterval!)
            fetchPriceInterval(date){
                self.upDateChart()
            }
        case 1:
            segment = 1
            intervalPrice.removeAll()
            let dateInterval = Calendar.current.date(byAdding: .month, value: -1, to: Date())
            let date = getDate(dateInterval!)
            fetchPriceInterval(date){
                self.upDateChart()
            }
        default:
            segment = 2
            intervalPrice.removeAll()
            let dateInterval = Calendar.current.date(byAdding: .year, value: -1, to: Date())
            let date = getDate(dateInterval!)
            fetchPriceInterval(date){
                self.upDateChart()
            }
        }
    }
    
    // MARK: - Update chart
    func upDateChart(){
        var lineChartEntry = [ChartDataEntry]()
        if segment == 0{
            lineChartEntry = self.fullChart(from: 0,to:7,by:1)
        }
        if segment == 1{
            lineChartEntry = fullChart(from: 7,to:30,by:7)
        }
        if segment == 2{
            lineChartEntry = fullChart(from: 0,to:365,by:31)
        }
        let line = LineChartDataSet(values: lineChartEntry, label: "Rate")
        line.colors = [NSUIColor.blue]
        let data = LineChartData()
        data.addDataSet(line)
        chrChart.data = data
        chrChart.chartDescription?.text = "Bitcoin charts"
    }
    
    func fetchPriceInterval(_ from:String,complition:@escaping ()->()){
        let result = getDate(Date())
        Alamofire.request("https://api.coindesk.com/v1/bpi/historical/close.json?currency=\(segmentCourse)&start=\(from)&end=\(result)").responseJSON { response in
            if let result = response.result.value as? NSDictionary{
                if let bpi = result["bpi"] as? NSDictionary{
                    for element in bpi.allValues{
                        self.intervalPrice.append(element as! Double)
                    }
                    complition()
                }
            }
        }
    }
    
    func getDate(_ date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        return result
    }
    
    func fullChart(from:Int,to:Int,by:Int)->[ChartDataEntry]{
        var k = 1
        var lineChartEntry = [ChartDataEntry]()
        for i in stride(from: from, to: to, by: by) {
            let value = ChartDataEntry(x: Double(k), y: intervalPrice[i])
            lineChartEntry.append(value)
            k += 1
        }
        return lineChartEntry
    }
}
