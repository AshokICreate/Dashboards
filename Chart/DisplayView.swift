//
//  DisplayView.swift
//  Chart
//
//  Created by Phani on 17/11/15.
//  Copyright © 2015 MetricStream. All rights reserved.
//

import UIKit

protocol DisplayViewDelegate{
    func showPopup(viewController:UIViewController)
}

class DisplayView: UIView,UIGestureRecognizerDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    var data = [String:[String:ChartUnitData]]()
    var highValue:CGFloat = 0;
    var lowValue:CGFloat = 0;
    var xAxisKeys = [String]()
    var colorKeys = [String]()
    let colors = ReadColorsBundle.instance.getColors();
    var delegate:DisplayViewDelegate?
    var xAxisName:String?

}
