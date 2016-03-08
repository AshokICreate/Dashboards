//
//  ReadBundle.swift
//  Chart
//
//  Created by Phani on 18/11/15.
//  Copyright © 2015 MetricStream. All rights reserved.
//

import UIKit

class ReadColorsBundle: NSObject {
    
    static let instance = ReadColorsBundle()
    var colors = [UIColor]()
    
    func getUIColorFromRGB(rgbaValue:String) ->UIColor
    {
    
         //253;253;252;255
        
        let rgbComponents = rgbaValue.componentsSeparatedByString(";")
       
        let r = Float(rgbComponents[0])! / 255
        let g = Float(rgbComponents[1])! / 255
        let b = Float(rgbComponents[2])! / 255
        let a = Float(rgbComponents[3])! / 255
        
        
        return UIColor.init(colorLiteralRed:r, green:g, blue:b, alpha:a)
    }
    
    func getColors() -> [UIColor]
    {
        
        if(colors.count != 0)
        {
            return colors
        }
        
        if let path = NSBundle.mainBundle().pathForResource("ColorTheme.bundle/WhiteTheme.bundle/Root", ofType: "plist"),dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject]
        {
            let pieDict = dict["GraphColors"]
            
            let dictionary = pieDict as! Dictionary<String,String>
            
            for colorIndex in 1...dictionary.count
            {
                let color = dictionary[String(colorIndex)]
                colors.append(getUIColorFromRGB(color!))
            }
    
        }
        
        return colors;
    }
    
}
