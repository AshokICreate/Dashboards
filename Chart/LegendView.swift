//
//  Legend.swift
//  Chart
//
//  Created by Phani on 19/02/16.
//  Copyright © 2016 MetricStream. All rights reserved.
//

import UIKit

class LegendView: UIView {
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    var labelHeight:CGFloat = 0;
    var labelWidth:CGFloat = 0;
    var cirlceMeasure:CGFloat = 0;
    //space between legend values
    var horizSpace:CGFloat = 0;
    var verticalSpace:CGFloat = 0;
    
    var radius:CGFloat = 0;
    
    var fontSize: CGFloat = 0
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        setSize()
        
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

            let centerX = cirlceMeasure/2;
            let centerY = cirlceMeasure/2;

            let cirlceWidth = cirlceMeasure+4;
            
            var sum = 0;
            
            for (_, value) in self.values.enumerate()
            {
                sum = sum+value.characters.count;
            }
            
            let maxAvg = sum/self.values.count+1;
    
            labelWidth = cirlceWidth + CGFloat(maxAvg * 10);
            
            
            // no of columns needed
            let maxColumn:Int = Int(width / (labelWidth+horizSpace));
            
            var startX:CGFloat = 0;
            
            if maxColumn < self.values.count
            {
                startX = (width - (labelWidth+horizSpace)*CGFloat(maxColumn)+horizSpace)/2 ;
                
            }else
            {
                startX = (width - (labelWidth+horizSpace)*CGFloat(self.values.count)+horizSpace)/2
            }
            
            
            // no of rows needed
            var maxRows:Int = Int (height / (verticalSpace+labelHeight));
            
            let rows:Int = Int((self.values.count/maxColumn)+1);
            
            if (maxRows > rows)
            {
                maxRows = rows;
            }
            
            for (index, value) in self.values.enumerate()
            {
                
                let currentCol = Int(index%maxColumn);
                let currentRow = Int(index/maxColumn);
                
                if (currentRow >= maxRows) {break;}
                
                
                
                let labelX =  CGFloat(currentCol) * (labelWidth+horizSpace);
                let labelY = CGFloat(currentRow) * (labelHeight+verticalSpace);
                
                CGContextSaveGState(currentContext);
                
                let labelRect:CGRect = CGRectMake(startX + labelX+cirlceWidth,labelY,labelWidth-cirlceWidth,labelHeight);
                let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.init();
                paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
                paragraphStyle.alignment = NSTextAlignment.Left;
                
                //Ashok: Legend View Font Value Changed
                let attrs = [NSFontAttributeName: UIFont.systemFontOfSize(self.fontSize), NSParagraphStyleAttributeName: paragraphStyle];

                value.drawInRect(labelRect, withAttributes: attrs);
                
                CGContextRestoreGState(currentContext);
                let colorIndex = index % colors.count
                CGContextSetStrokeColor(currentContext, CGColorGetComponents(colors[colorIndex].CGColor))
                CGContextSetFillColor(currentContext, CGColorGetComponents(colors[colorIndex].CGColor))
                
                CGContextAddArc(currentContext,startX+labelX+centerX,labelY+centerY,radius, radians(0),radians(359.9), 0)
                CGContextClosePath(currentContext);
                CGContextFillPath(currentContext);
                
            }
            
            
        }
    }
    
    
    let values: [String]
    let colors:[UIColor]
    
    init(frame: CGRect, data:[String],colors:[UIColor]) {
        
        self.values = data;
        self.colors = colors;
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.values = [String]()
        self.colors = [UIColor]()
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
                let componentSizes = iPhoneComponents!["LegendView"] as? Dictionary<String, AnyObject>
                
                let radius: Int = (componentSizes!["radius"] as? Int)!
                let horizSpace: Int = (componentSizes!["horizSpace"] as? Int)!
                let verticalSpace: Int = (componentSizes!["verticalSpace"] as? Int)!
                let circleMeasure: Int = (componentSizes!["circleMeasure"] as? Int)!
                let labelHeight: Int = (componentSizes!["labelHeight"] as? Int)!
                let labelWidth: Int = (componentSizes!["labelWidth"] as? Int)!
                let fontSize: Int = (componentSizes!["fontSize"] as? Int)!
                
                self.radius = CGFloat(radius)
                self.horizSpace = CGFloat(horizSpace)
                self.verticalSpace = CGFloat(verticalSpace)
                self.cirlceMeasure = CGFloat(circleMeasure)
                self.labelHeight = CGFloat(labelHeight)
                self.labelWidth = CGFloat(labelWidth)
                self.fontSize = CGFloat(fontSize)
        }
    }

}
