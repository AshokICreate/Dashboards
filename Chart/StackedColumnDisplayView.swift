//
//  StackedColumnDisplayView.swift
//  Chart
//
//  Created by Phani on 18/11/15.
//  Copyright © 2015 MetricStream. All rights reserved.
//

import UIKit

class StackedColumnDisplayView: DisplayView {

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
            
            var barWidth = (xUnit-barSpace)
            
            if(barWidth>maxBarWidth)
            {
                barWidth = maxBarWidth
            }
            
            if let pointsAtXKey = self.data[xKey]
            {
                
                let x = xUnit * CGFloat(xIndex) + (xUnit - barWidth)/2
                
                var heightBuilt = self.frame.size.height;
                
                for (colorIndex, colorKey) in self.colorKeys.enumerate()
                {
                    
                    if let chartUnit = pointsAtXKey[colorKey]
                    {
                        
                        let barHeight = chartUnit.value * yUnit
                        
                        let y = heightBuilt - chartUnit.value * yUnit
                        
                        let viewIndex = barViewIndex+(xIndex*self.colorKeys.count) + colorIndex
                        
                        if let view = self.viewWithTag(viewIndex)
                        {
                            view.frame = CGRectMake(x, y, barWidth, barHeight)
                            
                        }else
                        {
                            
                            let view = UIView.init(frame: CGRectMake(x, y, barWidth, barHeight))
                            
                            let index = colorIndex % colors.count
                            view.backgroundColor = colors[index]
                            
                            view.tag = viewIndex;
                            self.addSubview(view);
                            
                            
                        }
                        
                        heightBuilt = y;
                        
                    }
                    
                }
            }
        }
    }
    
    
    let barViewIndex = 1000;

}
