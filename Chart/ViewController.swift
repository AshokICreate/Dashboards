//
//  ViewController.swift
//  Chart
//
//  Created by Phani on 04/11/15.
//  Copyright © 2015 MetricStream. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var dashboard:DashBoardView = DashBoardView.init(frame:CGRectZero);
    let loader = LoadingScreen.init();
    
    override func loadView() {
        
        
        loader.showLoading();
        let config = NSURLSessionConfiguration.defaultSessionConfiguration();
        config.HTTPAdditionalHeaders = ["Authorization" : "M2"]
        let request = NSMutableURLRequest(URL: NSURL(string: "http://vmisupdnatap/metricstream/m2/2.3/s999864/reports/R-100313/data")!)
        let session = NSURLSession(configuration: config)
        request.HTTPMethod = "POST"
        
        do{
            if let path = NSBundle.mainBundle().pathForResource("input", ofType: "json")
            {
                if let jsonData = NSData(contentsOfFile: path)
                {
                    let jsonDict = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions(rawValue: 0)) as? NSDictionary
                    
                    request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonDict!,options:NSJSONWritingOptions.init(rawValue: 0))
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
            
                    let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                        if let _ = response as? NSHTTPURLResponse {
                            self.dashboard.drawDashBoard(data!)
                            self.loader.hideLoading()
                        }
                    
                    })
            
                    task.resume()
                }
            }
        }catch let error as NSError {
                        // error handling
                        NSLog("error %@", error.description);
                    }
        self.view = dashboard
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.whiteColor()
        self.edgesForExtendedLayout = UIRectEdge.None;
        self.extendedLayoutIncludesOpaqueBars = false;
        self.automaticallyAdjustsScrollViewInsets = false;

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

