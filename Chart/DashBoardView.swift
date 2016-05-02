//
//  DashBoardView.swift
//  Chart
//
//  Created by Phani on 17/11/15.
//  Copyright © 2015 MetricStream. All rights reserved.
//

import UIKit

protocol DashboardDelegate{
    func showPopup(viewController:UIViewController)
}

class DashBoardView: UIScrollView,ChartDelegate, pieDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var charts:[UIView] = [UIView]();
    var dashboardDelegate:DashboardDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func drawDashBoard(jsonData:NSData) {

        var dimesions:[String] = [String]()
        var measures:[String] = [String]()
        var content:NSMutableDictionary?
        
        do {
            let jsonDict = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions(rawValue: 0)) as? NSDictionary
            if let jsonDict:NSDictionary = jsonDict {
                // work with dictionary here
                if let structure = jsonDict["structure"] as? NSDictionary
                {
                    if let cells:NSArray = structure["cell"] as? NSArray
                    {
                        
                        for colObj : AnyObject in cells {
                            if let cellObj = colObj as? NSDictionary {
                                
                                if let id:String = cellObj["id"] as? String
                                {
                                    if let value:String = cellObj["datatype"] as? String
                                    {
                                        if(value=="STRING")
                                        {
                                            dimesions.append(id);
                                        }else
                                        {
                                            measures.append(id);
                                        }
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                }
                if let contents = jsonDict["content"] as? NSDictionary
                {
                    content = NSMutableDictionary.init(dictionary: contents);
                }
                
                
                
            } else {
                // more error handling
            }
        } catch let error as NSError {
            // error handling
            NSLog("error %@", error.description);
        }
        
        if let data = content
        {
            var parser = Parser.init(jsonData: data, axisColumns: ["MONTH"]);
            let (columnData,columnAxisKeys) = parser.parseElements(measures);
            let columnChart = Chart.init(frame: CGRectZero, graph: ChartTypesEnum.Column,data:columnData,axisValues:columnAxisKeys,colorValues:measures,xAxisName:"Month",yAxisName:"Targets")
            
            columnChart.chartDelegate = self;
            
            parser = Parser.init(jsonData: data, axisColumns: ["DEPARTMENT"]);
            let (lineData,lineAxisKeys) = parser.parseElements(measures);
            
            let lineChart = Chart.init(frame: CGRectZero, graph: ChartTypesEnum.Line,data:lineData,axisValues:lineAxisKeys,colorValues:measures,xAxisName:"Department",yAxisName:"Targets")
            lineChart.chartDelegate = self;
            
            
            parser = Parser.init(jsonData: data, axisColumns: ["LOCALE"]);
            let (stackedData,stackedAxisKeys) = parser.parseElements(measures);
            
            let stackedColumn = Chart.init(frame: CGRectZero, graph: ChartTypesEnum.StackedColumn,data:stackedData,axisValues:stackedAxisKeys,colorValues:measures,xAxisName:"Locale",yAxisName:"Targets")
            stackedColumn.chartDelegate = self;
            
            parser = Parser.init(jsonData: data, axisColumns: ["DEPARTMENT"]);
            let colorKey = measures[0] as String
            let (piedata,pieaxisKeys) = parser.parseElementsForPie(colorKey);
            
            let pieChart = PieChart.init(frame: CGRectZero,data:piedata,colorValues:pieaxisKeys,xAxisName:"Department",yAxisName:"Targets");
            pieChart.delegate = self
            
    
            
            self.addSubview(columnChart)
            self.addSubview(lineChart)
            self.addSubview(stackedColumn)
            self.addSubview(pieChart)
            
            charts.append(columnChart)
            charts.append(lineChart)
            charts.append(pieChart)
            charts.append(stackedColumn)
            
            
            //self.backgroundColor = UIColor.grayColor()
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
    
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        
        let width = self.frame.size.width;
        let height:CGFloat  = 1000;
        
        
        self.contentSize  = CGSizeMake(width, 2 * height)
        var index:CGFloat=0;
        for view in self.charts
        {
            view.frame = CGRectMake(0, index * height, width, height/2);
            index = index + 0.5;
        }
        
//        if(width>height)
//        {
//            
//            self.contentSize  = CGSizeMake(2 * width, height);
//            
//            var index:CGFloat=0;
//            for view in self.charts
//            {
//                view.frame = CGRectMake(index * width, 0, width/2, height);
//                index = index + 0.5;
//            }
//        
//            
//        }else
//        {
//            self.contentSize  = CGSizeMake(width, 2 * height)
//            var index:CGFloat=0;
//            for view in self.charts
//            {
//                view.frame = CGRectMake(0, index * height, width, height/2);
//                index = index + 0.5;
//            }
//        }
        
        
    }
    
    func showPopup(viewController: UIViewController) {
        dashboardDelegate!.showPopup(viewController);
    }
}
