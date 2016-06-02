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

    var lineWidth:CGFloat = 0//1.5
    var radius:CGFloat = 0//2.0
    
    var popupWidth: CGFloat = 0
    var popupHeight: CGFloat = 0
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        setSize()
        
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
                            
                            let viewIndex = lineViewIndex+(xIndex*self.colorKeys.count) + colorIndex
                            
                            if let view = self.viewWithTag(viewIndex)
                            {
                                view.frame = CGRectMake(x-20, y-20, 40, 40)
                                
                            }else
                            {
                                let view = UIView.init(frame: CGRectMake(x-20, y-20, 40, 40))
                                
                                view.backgroundColor = UIColor.clearColor();
                                view.tag = viewIndex
                                self.addSubview(view)
                                
                                let touch = UITapGestureRecognizer.init(target: self, action: "tapped:")
                                touch.delegate = self;
                                view.addGestureRecognizer(touch);
                                
                            }
    
                        }
                        
                    }
                    
                }
                
                
                
                CGContextAddLines(currentContext, points, points.count)
                CGContextStrokePath(currentContext)
                
            }
            
        }
    }
    
    func tapped(recognizer:UITapGestureRecognizer)
    {
        let viewIndex = (recognizer.view?.tag)! - lineViewIndex;
        let axisIndex = viewIndex/self.colorKeys.count;
        let colorIndex = viewIndex % self.colorKeys.count;
        let axisKey = self.xAxisKeys[axisIndex];
        let colorKey = self.colorKeys[colorIndex];
        
        let width = recognizer.view?.frame.size.width;
        
        if let pointsAtXKey = self.data[axisKey]
        {
            if let chartUnit = pointsAtXKey[colorKey]
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("popup") as UIViewController
                
                vc.modalPresentationStyle = UIModalPresentationStyle.Popover
                vc.preferredContentSize = CGSizeMake(self.popupWidth, self.popupHeight)
                vc.popoverPresentationController?.sourceRect = CGRect(x: (width!/2), y: 1, width:0, height:0);
                vc.popoverPresentationController?.sourceView = recognizer.view;
                
                let popupView:PopupView = vc.view as! PopupView;
                popupView.header1?.text = xAxisName;
                popupView.header2?.text = chartUnit.colorName;
                popupView.label1?.text = chartUnit.xname;
                popupView.label2?.text = String(chartUnit.value);
                
                
                let index = colorIndex % colors.count
                popupView.header1?.textColor = colors[index]
                popupView.header2?.textColor = colors[index]
                
                delegate?.showPopup(vc);
                
            }
        }
        
    }
    
    
    let lineViewIndex = 1000;
    
    override func layoutSubviews(){
        self.setNeedsDisplay();
    }
    
    func setSize() {
        
        let deviceType = UIDevice.currentDevice()
        
        if let path = NSBundle.mainBundle().pathForResource("Size", ofType: "plist"),
            dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                
                let iPhoneComponents = dict[deviceType.model] as? Dictionary<String, AnyObject>
                let componentSizes = iPhoneComponents!["LinesDisplayView"] as? Dictionary<String, AnyObject>
                let radius: Int = (componentSizes!["radius"] as? Int)!
                let lineWidth: Int = (componentSizes!["lineWidth"] as? Int)!
                
                self.radius = CGFloat(radius)
                self.lineWidth = CGFloat(lineWidth)
                
                let popupComponentSizes = iPhoneComponents!["PopupView"] as? Dictionary<String, AnyObject>
                let tempPopupWidth: Int = (popupComponentSizes!["popupWidth"] as? Int)!
                let tempPopupHeight: Int = (popupComponentSizes!["popupHeight"] as? Int)!
                
                self.popupWidth =  CGFloat(tempPopupWidth)
                self.popupHeight = CGFloat(tempPopupHeight)
        }
    }
}
