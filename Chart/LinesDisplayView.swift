//
//  LinesDisplayView.swift
//  Chart
//
//  Created by Phani on 17/11/15.
//  Copyright © 2015 MetricStream. All rights reserved.
//

import UIKit

let PI:CGFloat = 3.14159265358979323846

func radians(degrees:CGFloat) ->CGFloat { return degrees * PI / 180; }

class LinesDisplayView: DisplayView {

    let lineWidth:CGFloat = 2.5//1.5
    let radius:CGFloat = 6.0//2.0
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        if let currentContext = UIGraphicsGetCurrentContext(){
            
            CGContextClearRect(currentContext, rect)
            CGContextAddRect(currentContext, rect)
            CGContextSetRGBFillColor(currentContext,1.0,1.0,1.0,1.0)
            CGContextFillPath(currentContext)
         
            let xUnit = (self.frame.size.width)/CGFloat(self.xAxisKeys.count)
            let yUnit = (self.frame.size.height)/(highValue-lowValue)
            
            CGContextSetLineWidth(currentContext,lineWidth)
            
            for (colorIndex, colorKey) in self.colorKeys.enumerate()
            {
                
                var points = [CGPoint]();
                
                let index = colorIndex % colors.count
                CGContextSetStrokeColor(currentContext, CGColorGetComponents(colors[index].CGColor))
                CGContextSetFillColor(currentContext, CGColorGetComponents(colors[index].CGColor))
                
                
                for (xIndex, xKey) in self.xAxisKeys.enumerate()
                {
                    
                    if let pointsAtXKey = self.data[xKey]
                    {
                        if let chartUnit = pointsAtXKey[colorKey]
                        {
                            
                            let x = xUnit * CGFloat(xIndex) + xUnit/2;
                            let y = self.frame.size.height - yUnit * chartUnit.value;
                            points.append(CGPointMake(x, y))
                            
                            
                            CGContextMoveToPoint(currentContext,x, y)
                            CGContextAddArc(currentContext,x,y,radius, radians(0),radians(360), 0);
                            CGContextClosePath(currentContext);
                            CGContextFillPath(currentContext);
    
                        }
                        
                    }
                    
                }
                
                
                
                CGContextAddLines(currentContext, points, points.count)
                CGContextStrokePath(currentContext)
                
            }
            
        }
    }
    
    override func layoutSubviews(){
        self.setNeedsDisplay();
    }
    
}
