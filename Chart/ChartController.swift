//
//  ChartController.swift
//  Dashboards
//
//  Created by Phani on 06/06/16.
//  Copyright © 2016 MetricStream. All rights reserved.
//

import UIKit;

class ChartController: UIViewController {
    
    var index : NSInteger = 0
    var chart:Chart?;
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, chart1:Chart,index1:NSInteger) {
        chart =  chart1;
        index = index1;
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Here you can init your properties
        
    }
    
    override func loadView() {
        self.view = self.chart;
    }
    
    
    required init(coder aDecoder: NSCoder) {
    
        super.init(coder: aDecoder)!
    }

    
}
