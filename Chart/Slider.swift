//
//  Slider.swift
//  Dashboards
//
//  Created by Phani on 03/06/16.
//  Copyright © 2016 MetricStream. All rights reserved.
//

import UIKit

protocol SliderDelegate{
    func reArrangeXValues(startIndex:Int,endIndex:Int);
}

class Slider: UIView {

    var sliderBase  = UIView.init(frame: CGRectZero);
    var slide = UIView.init(frame: CGRectZero);
    var showPoints:Int = 10;
    var maxPoints:Int=15;
    var delegate:SliderDelegate?
    
    override init(frame: CGRect) {
        
        sliderBase.backgroundColor = UIColor.lightGrayColor();
        
        slide.layer.shadowOffset = CGSizeMake(1, 1);
        slide.layer.shadowColor = UIColor.blackColor().CGColor;
        slide.layer.shadowRadius = 3.0;
        slide.layer.shadowOpacity = 0.50;
    
        slide.backgroundColor = UIColor.whiteColor();
        
        
        super.init(frame: frame);
        
        self.addSubview(sliderBase);
        self.addSubview(slide);
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(Slider.handlePan(_:)))
        self.slide.addGestureRecognizer(gestureRecognizer)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    override func layoutSubviews() {
        
        let width = self.frame.size.width;
        var height:CGFloat = 20;
        var sliderBaseHeight:CGFloat = 4;
        
        let deviceType = UIDevice.currentDevice()
        
        if let path = NSBundle.mainBundle().pathForResource("Size", ofType: "plist"),
            dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            
            let iPhoneComponents = dict[deviceType.model] as? Dictionary<String, AnyObject>
            let componentSizes = iPhoneComponents!["Slider"] as? Dictionary<String, AnyObject>
            height = (componentSizes!["SliderHeight"] as? CGFloat)!
            sliderBaseHeight = (componentSizes!["SliderBaseHeight"] as? CGFloat)!
            
        }
        
        
        
        
        let slideWidth:CGFloat = (CGFloat(width-20)/CGFloat(maxPoints)) * CGFloat(showPoints);
        
//        if(slideWidth<30)
//        {
//            slideWidth = 30;
//            
//        }else if(slideWidth > width/3 )
//        {
//            slideWidth = width/4;
//        }
        
        
        sliderBase.frame = CGRectMake(10,(height-3)/2,width-20,sliderBaseHeight);
        slide.frame = CGRectMake(10,0,slideWidth,height);
        
        slide.layer.cornerRadius = height/2;
    }
    
    func handlePan(gestureRecognizer: UIPanGestureRecognizer)
    {
        if gestureRecognizer.state == UIGestureRecognizerState.Began || gestureRecognizer.state == UIGestureRecognizerState.Changed {
            
            let translation = gestureRecognizer.translationInView(self)
            
            
            gestureRecognizer.view!.center = CGPointMake(gestureRecognizer.view!.center.x + translation.x, gestureRecognizer.view!.center.y)
            
            if(gestureRecognizer.view!.frame.origin.x < self.sliderBase.frame.origin.x)
            {
                gestureRecognizer.view!.frame.origin.x = self.sliderBase.frame.origin.x;
                
            }else if(gestureRecognizer.view!.frame.origin.x + gestureRecognizer.view!.frame.size.width > self.sliderBase.frame.origin.x+self.sliderBase.frame.size.width)
            {
                gestureRecognizer.view!.frame.origin.x = self.sliderBase.frame.origin.x+self.sliderBase.frame.size.width - gestureRecognizer.view!.frame.size.width;
            }
            
            gestureRecognizer.setTranslation(CGPointMake(0,0), inView: self)
            
        }else if gestureRecognizer.state == UIGestureRecognizerState.Ended
        {
            let unit:CGFloat =  self.sliderBase.frame.size.width / CGFloat(maxPoints);
    
            
            let startIndex =  (gestureRecognizer.view!.frame.origin.x - self.sliderBase.frame.origin.x)/unit;
            let endIndex = (gestureRecognizer.view!.frame.origin.x - self.sliderBase.frame.origin.x + gestureRecognizer.view!.frame.size.width)/unit;
            
            print(startIndex,endIndex-1);
            self.delegate?.reArrangeXValues(Int(startIndex),endIndex: Int(endIndex));
            
            
        }
    }
}
