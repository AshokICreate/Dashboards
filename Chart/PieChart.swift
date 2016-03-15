//
//  PieChart.swift
//  Chart
//
//  Created by Phani on 18/11/15.
//  Copyright © 2015 MetricStream. All rights reserved.
//

import UIKit


class PieChart: UIView {

    
    var total:CGFloat = 0;
    let data:[String:ChartUnitData];
    let colorKeys:[String];
    let colors = ReadColorsBundle.instance.getColors();
    let legendView:LegendView;
    let titleView:UILabel;
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let otherViewsHeight:CGFloat = 160;
        let width = self.frame.size.width
        let height = self.frame.size.height-otherViewsHeight
        let centerX = width/2
        let centerY = height/2+otherViewsHeight/2;
        
        let radius = width < height ? (width/2) : (height/2)
        let innerRadius = radius * 0.6;
        
        
        if let currentContext = UIGraphicsGetCurrentContext(){
            
            CGContextClearRect(currentContext, rect)
            CGContextAddRect(currentContext, rect)
            CGContextSetRGBFillColor(currentContext,1.0,1.0,1.0,1.0)
            CGContextFillPath(currentContext)
            
            CGContextSetLineWidth(currentContext, radius-innerRadius)
            
            CGContextSaveGState(currentContext)
            let myShadowOffset = CGSizeMake (-10, 5)
            CGContextSetShadow(currentContext, myShadowOffset, 5)
            
            CGContextSetRGBStrokeColor(currentContext,1.0,1.0,1.0,1.0)
            CGContextAddArc(currentContext,centerX,centerY,innerRadius+(radius-innerRadius)/2, radians(0),radians(360), 0)
            CGContextStrokePath(currentContext)
            
            CGContextRestoreGState(currentContext)
            
            
            var startAngle:CGFloat = 0, endAngle:CGFloat = 0;
            
            let diff:CGFloat = 0
            let angle = CGFloat(360 - CGFloat(self.colorKeys.count) * diff);
            
            for (colorIndex,colorKey) in self.colorKeys.enumerate()
            {
                if let chartUnit:ChartUnitData = self.data[colorKey]
                {
                    let angle = radians((chartUnit.value / total) * angle)
                    endAngle = startAngle + angle
                    
                    let index = colorIndex % colors.count
                    let color = colors[index];
                    
                    
                    CGContextSetStrokeColor(currentContext, CGColorGetComponents(color.CGColor))
                    CGContextAddArc(currentContext,centerX,centerY,innerRadius+(radius-innerRadius)/2, startAngle,endAngle, 0)
                    CGContextStrokePath(currentContext)
                        
                    
                    startAngle = endAngle+radians(diff)
                }
                
            }
            
            
            
        }
        
        
        
    }
    
    
    init(frame: CGRect,data:[String:ChartUnitData],colorValues:[String],xAxisName:String,yAxisName:String) {
        
        
        self.data = data;
        self.colorKeys = colorValues;

        for (_ , graphUnit ) in data
        {
            self.total = total+graphUnit.value;
            
        }
        
        legendView = LegendView.init(frame: CGRectZero, data: self.colorKeys,colors:colors);
        titleView = UILabel.init(frame: CGRectZero);
        titleView.textAlignment = NSTextAlignment.Center;
        titleView.text = xAxisName+" Vs "+yAxisName;
        
         super.init(frame: frame)
         self.addSubview(legendView)
         self.addSubview(titleView);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        legendView = LegendView.init(coder: aDecoder)!
        titleView = UILabel.init(coder: aDecoder)!
        self.data = [String:ChartUnitData]();
        self.colorKeys = [String]()
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        let legendSpace:CGFloat = 60
        titleView.frame = CGRect(x:0, y:20, width:self.frame.size.width, height:40);
        legendView.frame = CGRect(x:10, y:self.frame.size.height-legendSpace+5, width:self.frame.size.width-15, height:legendSpace-10);
        self.setNeedsDisplay()
        
        let layer = CALayer.init();
        layer.backgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0).CGColor;
        layer.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1.0, CGRectGetWidth(self.frame), 1.0);
        
        self.layer.addSublayer(layer);
    }

}
