//
//  ColumnGraph.swift
//  Chart
//
//  Created by Phani on 09/11/15.
//  Copyright © 2015 MetricStream. All rights reserved.
//

import UIKit

class Chart: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    let yaxis:YAxis,xaxis:XAxis,displayView:DisplayView,legendView:LegendView
    let colors = ReadColorsBundle.instance.getColors()
    
    init(frame: CGRect, graph: ChartTypesEnum,data:[String:[String:ChartUnitData]],axisValues:[String],colorValues:[String]) {
    
        
        var high:CGFloat = 0.0;
        
        
        if(graph == ChartTypesEnum.StackedColumn)
        {
            for (_ , values ) in data
            {
                var sum:CGFloat = 0.0;
                for (_ , graphUnit ) in values
                {
                    sum = sum + graphUnit.value;
                    
                }
                
                if(sum > high)
                {
                    high = sum;
                }
                
            }
            
        }else
        {
            for (_ , values ) in data
            {
                
                for (_ , graphUnit ) in values
                {
                    if( graphUnit.value > high)
                    {
                        high = graphUnit.value
                    }
                    
                }
                
            }
        }
        
        var remain = Int(high / 5)+1 ;
        
        if(remain%2==1)
        {
            remain = remain + 1;
        }
        
        high =  CGFloat (remain * 5);
        
        
        
        yaxis = YAxis.init(frame: CGRectZero, low: 0, high: high, units:5)
        xaxis = XAxis.init(frame: CGRectZero, data: axisValues)
        
        displayView = ChartFactory.instance.createGraph(graph)
        
        displayView.data = data;
        displayView.highValue = high;
        displayView.lowValue = 0;
        displayView.xAxisKeys = axisValues;
        displayView.colorKeys = colorValues;
        
        legendView = LegendView.init(frame: CGRectZero, data: colorValues,colors:colors);
        super.init(frame: frame)
        
        
        
        self.addSubview(xaxis);
        self.addSubview(yaxis);
        self.addSubview(displayView);
        self.addSubview(legendView);
        
    }

    required init?(coder aDecoder: NSCoder) {
        yaxis = YAxis.init(coder: aDecoder)!
        xaxis = XAxis.init(coder: aDecoder)!
        displayView = DisplayView.init(coder: aDecoder)!
        legendView = LegendView.init(coder: aDecoder)!
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        
        let startX:CGFloat = 80
        let startY:CGFloat = 15
        let legendSpace:CGFloat = 60
        
        let endX = self.frame.size.width - startX - 5
        let endY:CGFloat = self.frame.size.height-startY-60-legendSpace;
        
        displayView.frame = CGRect(x: startX, y:startY, width:endX, height:endY)
        yaxis.frame = CGRect(x: 0, y:startY-8, width: startX, height:endY+16)
        xaxis.frame = CGRect(x:startX, y:startY+endY, width:endX, height:60)
        legendView.frame = CGRect(x:10, y:self.frame.size.height-legendSpace+5, width:self.frame.size.width-15, height:legendSpace-10);
        
    }

}
