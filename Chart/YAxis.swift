//
//  YAxis.swift
//  Chart
//
//  Created by Phani on 06/11/15.
//  Copyright © 2015 MetricStream. All rights reserved.
//

import UIKit

class YAxis: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        if(self.values.count<1){
            return;
        }
        
        let height = rect.size.height;
        let width = rect.size.width;
        
        if let currentContext = UIGraphicsGetCurrentContext(){
            CGContextClearRect(currentContext, rect)
            CGContextAddRect(currentContext, rect)
            CGContextSetRGBFillColor(currentContext,1.0,1.0,1.0,1.0)
            CGContextFillPath(currentContext)
            
            
            let labelHeight:CGFloat = 16.0;
            
            CGContextSetStrokeColor(currentContext, CGColorGetComponents(UIColor.init(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).CGColor))
            CGContextSetLineWidth(currentContext,2.0)
            CGContextMoveToPoint(currentContext, width, labelHeight/2)
            CGContextAddLineToPoint(currentContext,width,height-labelHeight/2)
            CGContextStrokePath(currentContext)
            
            
            let labelX:CGFloat = 10.0;
            let labelWidth:CGFloat = width-CGFloat(2*labelX);
            
            let unitY:CGFloat = ((height-labelHeight)/CGFloat(self.values.count-1))
            
        
            for (index, value) in self.values.enumerate()
            {
                let labelY = height-unitY*CGFloat(index) - labelHeight
                let labelRect:CGRect = CGRectMake(labelX,labelY, labelWidth, labelHeight)
                let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.init();
                paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
                paragraphStyle.alignment = NSTextAlignment.Right;
                
                let attrs = [NSFontAttributeName: UIFont.systemFontOfSize(12), NSParagraphStyleAttributeName: paragraphStyle]

            
//                CGContextSetLineWidth(currentContext,0.8)
//                CGContextMoveToPoint(currentContext, width-2, labelHeight/2+(unitY*CGFloat(index)))
//                CGContextAddLineToPoint(currentContext,width, labelHeight/2+(unitY*CGFloat(index)))
//                CGContextStrokePath(currentContext)
                
                value.drawInRect(labelRect, withAttributes: attrs)
            
            }
            
        }
    }


    let values: [String]
    
    init(frame: CGRect, data:[String]) {
        
        self.values = data;
        super.init(frame: frame)
    }
    
    
    init(frame: CGRect, low:CGFloat, high:CGFloat, units:Int) {
        
        let difference = (high-low)/CGFloat(units);
        var data = [String]()
        for index in 0...units
        {
            
            let value = low+(difference*CGFloat(index))
            data.append(String(Int(value)))
            
        }
        
        self.values = data;
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.values = [String]()
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        self.setNeedsDisplay();
    }
    
  
    
    

}
