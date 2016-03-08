//
//  Parser.swift
//  Chart
//
//  Created by Phani on 29/02/16.
//  Copyright © 2016 MetricStream. All rights reserved.
//

import UIKit

class Parser: NSObject {
    
    var jsonData:NSDictionary
    var axisColumns:[String]
    
    init(jsonData: NSDictionary, axisColumns:[String]) {
        
        self.jsonData = jsonData
        self.axisColumns = axisColumns
        super.init()
    }
    
    func parseElementsForPie(colorName:String) -> ([String:ChartUnitData],[String])
    {
        
        var pieData:[String:ChartUnitData] = [String:ChartUnitData]();
        var axisKeys:[String] = [String]()
        
        if let rows:NSArray = self.jsonData["rows"]as? NSArray
        {
            for obj : AnyObject in rows {
                
                if let rowObject = obj as? NSDictionary
                {
                    var cell = [String:String]()
                    if let cells = rowObject["cells"] as? NSArray {
                        
                        for colObj : AnyObject in cells {
                            if let cellObj = colObj as? NSDictionary {
                                
                                if let id:String = cellObj["id"] as? String
                                {
                                    if let value:String = cellObj["value"] as? String
                                    {
                                        cell[id] = value;
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    var axisValue="";
                    
                    for(axisKey) in axisColumns
                    {
                        axisValue += cell[axisKey]!;
                    }
                    
                    
                    if(!axisKeys.contains(axisValue))
                    {
                        axisKeys.append(axisValue);
                        
                        
                        let stringValue:String = cell[colorName]!
                        let value = CGFloat((stringValue as NSString).doubleValue)
                        let graphUnit = ChartUnitData.init(xname: axisValue, yname: colorName, colorName:colorName, value: value);
                        pieData[axisValue] = graphUnit;
                        
                    }else
                    {
                        let graphUnit:ChartUnitData = pieData[axisValue]!;
                        let stringValue:String = cell[colorName]!
                        let value = CGFloat((stringValue as NSString).doubleValue)
                        graphUnit.value += value;
                        
                    }
                    
                }
                
            }
        }
        
        return (pieData,axisKeys);
        
    }
    
    func parseElements(colorKeys:[String]) -> ([String:[String:ChartUnitData]],[String])
    {
        var data:[String:[String:ChartUnitData]] = [String:[String:ChartUnitData]]()
        var axisKeys:[String] = [String]()
        
        if let rows:NSArray = self.jsonData["rows"]as? NSArray
        {
            for obj : AnyObject in rows {
                
                if let rowObject = obj as? NSDictionary
                {
                    var cell = [String:String]()
                    if let cells = rowObject["cells"] as? NSArray {
                        
                        for colObj : AnyObject in cells {
                            if let cellObj = colObj as? NSDictionary {
                                
                                if let id:String = cellObj["id"] as? String
                                {
                                    if let value:String = cellObj["value"] as? String
                                    {
                                        cell[id] = value;
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    var axisValue="";
                    
                    for(axisKey) in axisColumns
                    {
                        axisValue += cell[axisKey]!;
                    }
                    
                    
                    if(!axisKeys.contains(axisValue))
                    {
                        axisKeys.append(axisValue);
                        var arryValues = [String:ChartUnitData]()
                        for(clrName) in colorKeys
                        {
                            let stringValue:String = cell[clrName]!
                            let value = CGFloat((stringValue as NSString).doubleValue)
                            let graphUnit = ChartUnitData.init(xname: axisValue, yname: clrName, colorName:clrName, value: value);
                            arryValues[clrName] = graphUnit
                        }
                        
                        data[axisValue] = arryValues;
                    }else
                    {
                        let arryValues:[String:ChartUnitData] = data[axisValue]!;
                        for(clrName) in colorKeys
                        {
                            let stringValue:String = cell[clrName]!
                            let value = CGFloat((stringValue as NSString).doubleValue)
                            let graphUnit = arryValues[clrName];
                            graphUnit!.value += value;
                            
                        }
                        
                    }
                    
                }
                
            }
        }
        
        return (data,axisKeys)
        
    }
    
}