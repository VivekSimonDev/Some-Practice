//
//  MyProgressController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-10-26.
//  Developers: Liam O'Shaughnessy
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit
import CoreData
//Vivek added:
import JBChart
//Vivek added JB terms:
class MyProgressController: UIViewController, JBBarChartViewDelegate, JBBarChartViewDataSource {
    @IBOutlet weak var stackView: UIStackView!
    //Vivek added:
    @IBOutlet weak var barChart: JBBarChartView!
    //Vivek added:
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Vivek added:
    var chartLegend = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    //Vivek added:
    var chartData = [70, 80, 76, 88, 90, 69, 74]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Vivek added:
        view.backgroundColor = UIColor.darkGray
        //Vivek added:
        //bar chart setup
        barChart.backgroundColor = UIColor.darkGray
        barChart.delegate = self
        barChart.dataSource = self
        barChart.minimumValue = 0
        barChart.maximumValue = 100
        
        //to-do add footer, header
        
        barChart.reloadData()
        
        barChart.setState(.collapsed, animated: false)
        //end of Vivek's addition/////////////////////////////////////////////////
        let leftEdge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector (handleSwipes(_:)))
        
        let rightEdge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector (handleSwipes(_:)))
        
        leftEdge.edges = .left
        rightEdge.edges = .right
        
        view.addGestureRecognizer(leftEdge)
        view.addGestureRecognizer(rightEdge)
        // Do any additional setup after loading the view, typically from a nib.
        for view in stackView.subviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    //Vivek added:
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //our code
        barChart.reloadData()
        var timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: Selector("showChart"), userInfo: nil, repeats: false)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        populateStackView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //Vivek added:
        super.viewDidDisappear(animated)
        hideChart()
        ///End of Vivek's addition/////////////////////////
        for view in stackView.subviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    //Vivek added:
    func hideChart() {
        barChart.setState(.collapsed, animated: true)
    }
    
    //Vivek added:
    func showChart() {
        barChart.setState(.expanded, animated: true)
    }
    
    //MARK:JBBarChartView
    
    //Vivek added:
    func numberOfBars(in barChartView: JBBarChartView!) -> UInt {
        return UInt(chartData.count)
    }
    
    //Vivek added:
    func barChartView(_ barChartView: JBBarChartView!, heightForBarViewAt index: UInt) -> CGFloat {
        return CGFloat(chartData[Int(index)])
    }
    
    //Vivek added:
    func barChartView(_ barChartView: JBBarChartView!, colorForBarViewAt index: UInt) -> UIColor! {
        return (index % 2 == 0) ? UIColor.red : UIColor.lightGray
    
    }
    
    //Vivek added:
    func barChartView(_ barChartView: JBBarChartView!, didSelectBarAt index: UInt) {
        let data = chartData[Int(index)]
        let key = chartLegend[Int(index)]
        
        informationLabel.text = "Weather on \(key): \(data)"
    }
    
    //Vivek added:
    func didDeselect(_ barChartView: JBBarChartView!) {
        informationLabel.text = ""
    }
    
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize.height = stackView.frame.height + 200
        scrollView.isScrollEnabled = true;
        scrollView.isUserInteractionEnabled = true;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showPopup(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tilePopUpID") as! ExerciseTileViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    func handleSwipes(_ recognizer: UIScreenEdgePanGestureRecognizer){
        if (recognizer.state == .recognized) {
            if(recognizer.edges == .left) {
                print("Swipe Right from left edge ")//dummy code
                }
            if(recognizer.edges == .right) {
                print("Swipe Left from right edge") //dummy code
                }
        }
        //NEED TO GET ARRAY DATA AND CHANGE TILES IN THE VIEW CONTROLLER
    }
    
    func populateStackView() {
        let exerciseArrayCount = DataHandler.getExerciseArrayCount()
        if (exerciseArrayCount == 0) {
            //Display Placeholder Exercise Tile
            print("Works")
        } else {
            //Populate Exercise Tiles
            let exerciseArray = DataHandler.getExerciseArray()

            for elem in exerciseArray {
                if (elem.category == elem.CATEGORY_CARDIO) {
                    let tile = CardioTileView(name: elem.exerciseName, time: elem.time, speed: elem.speed, resistance: elem.resistance)
                    stackView.addArrangedSubview(tile)
                } else {
                    let tile = StrengthTileView(name: elem.exerciseName, sets: elem.sets, reps: elem.reps)
                    stackView.addArrangedSubview(tile)
                }
            }
        }
    }
    
    func createTile() {
        
    }
}

