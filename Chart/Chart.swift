//
//  ColumnGraph.swift
//  Chart
//
//  Created by Phani on 09/11/15.
//  Copyright © 2015 MetricStream. All rights reserved.
//

import UIKit

protocol ChartDelegate{
    func showPopup(viewController:UIViewController);
}

class Chart: UIView, DisplayViewDelegate,SliderDelegate,LegendProtocol {


    /*
    // Only override drawRect: if you perform customvarawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var startX:CGFloat = 0
    var startY:CGFloat = 0
    var legendSpace:CGFloat = 0
    var minPoints:Int = 12
    
    let yaxis:YAxis,xaxis:XAxis,displayView:DisplayView,legendView:LegendView,titleView:UILabel,slider:Slider
    let colors = ReadColorsBundle.instance.getColors()
    var chartDelegate:ChartDelegate?
    
    let xAxisKeys,colorKeys:[String]?
    let data:[String:[String:ChartUnitData]];
    let graph: ChartTypesEnum;
    init(frame: CGRect, graph: ChartTypesEnum,data:[String:[String:ChartUnitData]],axisValues:[String],colorValues:[String],xAxisName:String,yAxisName:String) {
      
        self.data = data;
        self.graph = graph;
        let high = Chart.getHigh(graph,data,colorValues);
        yaxis = YAxis.init(frame: CGRectZero, low: 0, high: high, units:5)
        xaxis = XAxis.init(frame: CGRectZero)
        
        displayView = ChartFactory.instance.createGraph(graph)
        
        
        titleView = UILabel.init(frame: CGRectZero);
        titleView.textAlignment = NSTextAlignment.Center;
        titleView.text = xAxisName+" Vs "+yAxisName;
        
        legendView = LegendView.init(frame: CGRectZero, data: colorValues,colors:colors);
        slider = Slider.init(frame: CGRectZero);
        xAxisKeys = axisValues;
        colorKeys = colorValues;
        
        super.init(frame: frame)
        legendView.legenddelegate = self


      
        self.addSubview(xaxis);
        self.addSubview(yaxis);
        self.addSubview(displayView);
        self.addSubview(legendView);
        self.addSubview(titleView);
        self.addSubview(slider);
        
        setSize();
        
        
        slider.maxPoints = self.xAxisKeys!.count;
        slider.showPoints = self.minPoints/self.colorKeys!.count;
        slider.delegate = self;
      
      if(slider.showPoints>axisValues.count){
        slider.showPoints = axisValues.count
      }
        
        let xValues = Array(axisValues[0..<slider.showPoints]);
        displayView.data = data;
        displayView.highValue = high;
        displayView.lowValue = 0;
        displayView.xAxisKeys = xValues;
        displayView.colorKeys = colorValues;
        displayView.showKeys = colorValues;
        displayView.xAxisName = xAxisName;

        displayView.delegate = self;
        
        xaxis.values = xValues;
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        yaxis = YAxis.init(coder: aDecoder)!
        xaxis = XAxis.init(coder: aDecoder)!
        displayView = DisplayView.init(coder: aDecoder)!
        legendView = LegendView.init(coder: aDecoder)!
        titleView = UILabel.init(coder: aDecoder)!
        slider = Slider.init(coder: aDecoder)!
        xAxisKeys = [String]();
        colorKeys = [String]();
        self.data = [String:[String:ChartUnitData]]();
      self.graph = ChartTypesEnum.Bar;
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        
       /* let startX:CGFloat = 80
        let startY:CGFloat = 75
        let legendSpace:CGFloat = 60 */
        
       /* let startX:CGFloat = 63
        let startY:CGFloat = 60
        let legendSpace:CGFloat = 50 */
        
        let xAxisHeight:CGFloat = 60;
        let sliderSpace:CGFloat = 50;
        let endX = self.frame.size.width - startX - 5
        let endY:CGFloat = self.frame.size.height-startY-xAxisHeight-legendSpace-sliderSpace;
        
        titleView.frame = CGRect(x:0, y:20, width:self.frame.size.width, height:40);
        displayView.frame = CGRect(x: startX, y:startY, width:endX, height:endY)
        yaxis.frame = CGRect(x: 0, y:startY-8, width: startX, height:endY+16)
        xaxis.frame = CGRect(x:startX, y:startY+endY, width:endX, height:xAxisHeight)
        
        slider.frame = CGRect(x:startX, y:self.frame.size.height-legendSpace-sliderSpace, width:endX, height:20);
        legendView.frame = CGRect(x:10, y:self.frame.size.height-legendSpace+5, width:self.frame.size.width-15, height:legendSpace-10);
        
        
        let layer = CALayer.init();
        layer.backgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0).CGColor;
        layer.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1.0, CGRectGetWidth(self.frame), 1.0);
        
        self.layer.addSublayer(layer);
    }
    
    func showPopup(viewController: UIViewController) {
        chartDelegate!.showPopup(viewController);
    }
    
    func reArrangeXValues(startIndex:Int,endIndex:Int)
    {
        let xValues = Array(self.xAxisKeys![startIndex..<endIndex]);
        self.displayView.xAxisKeys = xValues;
        self.displayView.layoutSubviews();
        
        self.xaxis.values = xValues;
        self.xaxis.layoutSubviews();
    }
    
    func setSize() {
        
        let deviceType = UIDevice.currentDevice()
        
        if let path = NSBundle.mainBundle().pathForResource("Size", ofType: "plist"),
            dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                
                let iPhoneComponents = dict[deviceType.model] as? Dictionary<String, AnyObject>
                let componentSizes = iPhoneComponents!["Chart"] as? Dictionary<String, AnyObject>
                let startX: Int = (componentSizes!["startX"] as? Int)!
                let startY: Int = (componentSizes!["startY"] as? Int)!
                let legendSpace: Int = (componentSizes!["legendSpace"] as? Int)!
                let minPoints: Int = (componentSizes!["minPoints"] as? Int)!
                
                self.startX = CGFloat(startX)
                self.startY = CGFloat(startY)
                self.legendSpace = CGFloat(legendSpace)
                self.minPoints = minPoints;
            
        }
    }
  
    static func getHigh(graph: ChartTypesEnum,_ data:[String:[String:ChartUnitData]],_ colorKeys: [String]) -> CGFloat
    {
        var high:CGFloat = 0.0;
        
        
        if(graph == ChartTypesEnum.StackedColumn)
        {
          for (_ , values ) in data
          {
            var sum:CGFloat = 0.0;
            for (colorKey , graphUnit ) in values
            {
              
              if(colorKeys.contains(colorKey))
              {
                 sum = sum + graphUnit.value;
              }
              
              
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
            
            for (colorKey , graphUnit ) in values
            {
              if(colorKeys.contains(colorKey) && graphUnit.value > high)
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
      
        return high;
    }
    //MARK: Legend Delegate
  
    func tappedLegendValues(values: [String]){
        print("values from legend in chartveiws \(values)")
      
        let high = Chart.getHigh(self.graph,self.data,values);
        self.displayView.highValue = high
      
        self.displayView.colorKeys = values;
      self.yaxis.reDraw(0, high: high, units: 5);
      self.displayView.reDraw();
    }
    
   
}
