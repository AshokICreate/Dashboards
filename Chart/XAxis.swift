//
//  XAxis.swift
//  Chart
//
//  Created by Phani on 09/11/15.
//  Copyright © 2015 MetricStream. All rights reserved.
//

import UIKit

class XAxis: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var labelHeight:CGFloat = 0;
    var labelY:CGFloat = 0;
    var fontSize:CGFloat = 0
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        setSize()
        
        if(self.values.count<1){
            return;
        }
        
        let width = rect.size.width;
        
        if let currentContext = UIGraphicsGetCurrentContext(){
            
            CGContextClearRect(currentContext, rect)
            CGContextAddRect(currentContext, rect)
            CGContextSetRGBFillColor(currentContext,1.0,1.0,1.0,1.0)
            CGContextFillPath(currentContext)
            
            CGContextSetStrokeColor(currentContext, CGColorGetComponents(UIColor.init(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).CGColor))
            CGContextSetLineWidth(currentContext,2.0)
            CGContextMoveToPoint(currentContext, 0, 0)
            CGContextAddLineToPoint(currentContext,width,0)
            CGContextStrokePath(currentContext)
            
            
            let unitX:CGFloat = width/CGFloat(self.values.count)
            let labelWidth:CGFloat = unitX-CGFloat(labelY);
            
            if (labelWidth < 10.0 ) { return }
            
            for (index, value) in self.values.enumerate()
            {
                let labelX = unitX*CGFloat(index) + labelY/2
                let labelRect:CGRect = CGRectMake(labelX,labelY, labelWidth, labelHeight)
                let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.init();
                paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
                paragraphStyle.alignment = NSTextAlignment.Center;
                
                //Ashok font Value Changed for iPhone.
                let attrs = [NSFontAttributeName: UIFont.systemFontOfSize(self.fontSize), NSParagraphStyleAttributeName: paragraphStyle]
                
                CGContextSetLineWidth(currentContext,0.8)
                CGContextMoveToPoint(currentContext, (unitX*CGFloat(index) + unitX/2), 0)
                CGContextAddLineToPoint(currentContext,(unitX*CGFloat(index) + unitX/2),2)
                CGContextStrokePath(currentContext)
                
                value.drawInRect(labelRect, withAttributes: attrs)
            }
            
        }
    }
    
    let values: [String]
    
    init(frame: CGRect, data:[String]) {
        
        self.values = data;
        super.init(frame: frame)
    }
    
    
    init(frame: CGRect, low:Double, high:Double, units:Int) {
        
        let difference = (high-low)/Double(units);
        var data = [String]()
        for index in 0...units
        {
            
            let value = low+(difference*Double(index))
            data.append(String(value))
            
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
    
    func setSize() {
        
        let deviceType = UIDevice.currentDevice()
        
        if let path = NSBundle.mainBundle().pathForResource("Size", ofType: "plist"),
            dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                
                let iPhoneComponents = dict[deviceType.model] as? Dictionary<String, AnyObject>
                let componentSizes = iPhoneComponents!["XAxis"] as? Dictionary<String, AnyObject>
                let labelHeight: Int = (componentSizes!["labelHeight"] as? Int)!
                let labelY: Int = (componentSizes!["labelY"] as? Int)!
                let fontSize: CGFloat = (componentSizes!["fontSize"] as? CGFloat)!
                self.labelHeight = CGFloat(labelHeight)
                self.labelY = CGFloat(labelY)
                self.fontSize = fontSize
        }
    }


}
