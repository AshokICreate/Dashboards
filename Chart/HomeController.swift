//
//  HomeController.swift
//  Chart
//
//  Created by Phani on 14/03/16.
//  Copyright © 2016 MetricStream. All rights reserved.
//

import UIKit

class HomeController: UIViewController,UIGestureRecognizerDelegate
{
    @IBOutlet var report1:UIImageView?;
    @IBOutlet var report2:UIImageView?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Dashboards";
        
        let touch = UITapGestureRecognizer.init(target: self, action: "tapped:")
        touch.delegate = self;
        report1!.addGestureRecognizer(touch);
        
        let touch2 = UITapGestureRecognizer.init(target: self, action: "tapped:")
        touch2.delegate = self;
        report2!.addGestureRecognizer(touch2);
        
        
        let layer = self.report1!.layer;
        layer.shadowOffset = CGSizeMake(1, 1);
        layer.shadowColor = UIColor.blackColor().CGColor;
        layer.shadowRadius = 3.0;
        layer.shadowOpacity = 0.80;
        //layer.shadowPath = UIBezierPath.init(rect: layer.bounds).CGPath
        
        let layer2 = self.report2!.layer;
        layer2.shadowOffset = CGSizeMake(1, 1);
        layer2.shadowColor = UIColor.blackColor().CGColor;
        layer2.shadowRadius = 3.0;
        layer2.shadowOpacity = 0.80;
        
    }
    
    func tapped(recognizer:UITapGestureRecognizer)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("dashboard") as UIViewController;
        
        self.navigationController?.pushViewController(vc, animated: true);
        
        
    }
}