//
//  MyProgressController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-10-26.
//  Developers: Liam O'Shaughnessy, Vivek Sharma
//  Copyright © 2016 SimonDevs. All rights reserved.
//  Partial functionality adapted from a third party resource: https://github.com/thefirstnikhil/chartingdemo
//

import UIKit
import CoreData
//Vivek added:
import JBChart

//Vivek added: An extension to UIColor to allow the creation of our own colours using RGB numbers
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}


//Vivek added: 3rd party libraries added here
class MyProgressController: UIViewController, JBBarChartViewDelegate, JBBarChartViewDataSource {
    @IBOutlet weak var stackView: UIStackView!
    //Vivek added:
    @IBOutlet weak var barChart: JBBarChartView! //The view the bar chart rests in
    //Vivek added:
    @IBOutlet weak var informationLabel: UILabel! //The label that display info when a bar is tapped
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Vivek added:
    var chartLegend = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"] //x-axis information
    //Vivek added:
    var chartData = [5, 8, 6, 2, 9, 6, 4]//sample data to display bar graph, replace with actual exercise completion numbers
    //Vivek added:
    let SFURed = UIColor(red: 166, green: 25, blue: 46) //Creating a custom colour to match the SFU official red colour using the UIColor extension created above
    let SFUGrey = UIColor(red: 84, green: 88, blue: 90)//Customly create SFUGrey

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Vivek added:
        view.backgroundColor = UIColor.lightGray // changing the colour of whole view
        //Vivek added:
        //bar chart setup
        barChart.backgroundColor = SFURed //adjust colour of bars in graph
        barChart.delegate = self
        barChart.dataSource = self
        barChart.minimumValue = 0
        barChart.maximumValue = CGFloat(chartData.max()!) // max value of a bar in the graph is the max value from the data array. The visual height of each bar is relative to this value

        //NOTE: footer and header created below reduce size/space of the actual bar graph.
        
        //Creating a footer with appropriate Day labels. Spacing is hard coded unfortunately
        var footer = UILabel(frame: CGRect(x: 0, y: 0, width: barChart.frame.width, height: 16))
        footer.textColor = UIColor.black
        footer.text = "  \(chartLegend[0])     \(chartLegend[1])     \(chartLegend[2])    \(chartLegend[3])    \(chartLegend[4])    \(chartLegend[5])        \(chartLegend[6])"
        footer.textAlignment = NSTextAlignment.left

        //Creating a header.
        var header = UILabel(frame: CGRect(x: 0, y: 0, width: barChart.frame.width, height: 16))
        header.textColor = UIColor.black
        //header.font = UIFont.systemFont(ofSize: 24)
        header.text = "Workout Completion Chart"
        header.textAlignment = NSTextAlignment.center
        
        
        barChart.footerView = footer
        barChart.headerView = header
        
        
        
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
    
        barChart.reloadData()
        var timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: Selector("showChart"), userInfo: nil, repeats: false)
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
        return UIColor.white
        
    }
    
    //Vivek added:
    func barChartView(_ barChartView: JBBarChartView!, didSelectBarAt index: UInt) {
        let data = chartData[Int(index)]
        let key = chartLegend[Int(index)]
        
        informationLabel.text = "Workouts completed on \(key): \(data)"
        //Maybe change the bar graphs to a percentage, so that if all workouts are completed on that day, the bar is a maximum height.
    }
    
    //Vivek added:
    /*func didDeselect(_ barChartView: JBBarChartView!) {
        informationLabel.text = ""
    }*/
    
    
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

