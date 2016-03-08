//
//  GraphUnitData.swift
//  Chart
//
//  Created by Phani on 17/11/15.
//  Copyright © 2015 MetricStream. All rights reserved.
//

import UIKit

class ChartUnitData: NSObject {
    
    var xname:String
    var yname:String
    var value:CGFloat
    var colorName:String
    
    init(xname: String, yname:String, colorName:String,value:CGFloat) {
        
        self.xname = xname
        self.yname = yname
        self.value = value
        self.colorName = colorName
        super.init()
    }

}
