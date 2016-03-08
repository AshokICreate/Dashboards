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
            
            
            let labelHeight:CGFloat = 20.0;
            var labelWidth:CGFloat = 100.0;
            let cirlceMeasure:CGFloat = 16.0;
            //space between legend values
            let horizSpace:CGFloat = 10.0;
            let verticalSpace:CGFloat = 5.0;
            
            
            let centerX = cirlceMeasure/2;
            let centerY = cirlceMeasure/2;
            let radius:CGFloat = 5.0;
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
                
                let attrs = [NSFontAttributeName: UIFont.systemFontOfSize(12), NSParagraphStyleAttributeName: paragraphStyle];

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

}
