//
//  ColumnDisplayView.swift
//  Chart
//
//  Created by Phani on 17/11/15.
//  Copyright © 2015 MetricStream. All rights reserved.
//

import UIKit

class ColumnDisplayView: DisplayView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    let barSpace:CGFloat = 6.0
    let maxBarWidth:CGFloat = 40.0
    
    override func layoutSubviews() {
        self.drawChart();
    }
    
    func drawChart()
    {
        
        
        let xUnit = (self.frame.size.width)/CGFloat(self.xAxisKeys.count)
        let yUnit = (self.frame.size.height)/(highValue-lowValue)
        
        for (xIndex, xKey) in self.xAxisKeys.enumerate()
        {
            
            var barWidth = (xUnit-barSpace)/CGFloat(self.colorKeys.count)
            
            if(barWidth>maxBarWidth)
            {
                barWidth = maxBarWidth
            }
            
            if let pointsAtXKey = self.data[xKey]
            {
            
                for (colorIndex, colorKey) in self.colorKeys.enumerate()
                {
                
                    let x = xUnit * CGFloat(xIndex) + (xUnit - (barWidth*CGFloat(self.colorKeys.count)))/2 + barWidth * CGFloat(colorIndex)
                    
                    if let chartUnit = pointsAtXKey[colorKey]
                    {
                    
                        let barHeight = chartUnit.value * yUnit
                        
                        let y = self.frame.size.height - barHeight
                        
                        let viewIndex = barViewIndex+(xIndex*self.colorKeys.count) + colorIndex
                        
                        if let view = self.viewWithTag(viewIndex)
                        {
                            view.frame = CGRectMake(x, y, barWidth, barHeight)
                            
                        }else
                        {
                            let view = UIView.init(frame: CGRectMake(x, y, barWidth, barHeight))
                            
                            let index = colorIndex % colors.count
                            view.backgroundColor = colors[index]
                            view.tag = viewIndex
                            self.addSubview(view)
                            
                        }
                    }
                                        
                }
            }
        }
    }
    
    
    let barViewIndex = 1000;

}
