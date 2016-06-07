//
//  SplashViewController.swift
//  Dashboards
//
//  Created by Phani on 15/03/16.
//  Copyright © 2016 MetricStream. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController
{
    var companyFirstName: UILabel!
    var companyLastName: UILabel!
    var dashBoardLabel : UILabel!
    
    var fontSize: CGFloat = 0
    var firstNameWidth: CGFloat = 0
    var lastNameWidth: CGFloat = 0
    var dashBoardWidth: CGFloat = 0
    var dashBoardFontSize: CGFloat = 0
    var height: CGFloat = 0
    
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSize()
        
        let screenSize = UIScreen.mainScreen().bounds
        
        let companyOrignY = ((screenSize.size.height*30)/100)
        
        companyFirstName = UILabel(frame: CGRect(x: 0, y: screenSize.origin.y, width: self.firstNameWidth, height: 50))
        companyFirstName.frame.origin.x = self.view.center.x - self.companyFirstName.frame.width
        companyFirstName.text  = "Metric"
        companyFirstName.font = UIFont.boldSystemFontOfSize(self.fontSize)
        companyFirstName.numberOfLines = 0
        companyFirstName.adjustsFontSizeToFitWidth = false
        self.view .addSubview(companyFirstName)
        
        
        companyLastName = UILabel(frame: CGRect(x: 0, y: screenSize.size.height-50, width: self.lastNameWidth, height: 50))
        self.companyLastName.frame.origin.x = self.view.center.x;
        companyLastName.text  = "Stream"
        companyLastName.font = UIFont.boldSystemFontOfSize(self.fontSize)
        companyLastName.numberOfLines = 0
        companyLastName.adjustsFontSizeToFitWidth = false
        self.view.addSubview(companyLastName)
        
        //DashBoard Label
        let dashBoardOriginY = ((screenSize.size.height*34)/100) + 12
        
        dashBoardLabel = UILabel(frame: CGRect(x: 0 , y: dashBoardOriginY, width: self.dashBoardWidth, height: 50))
        self.dashBoardLabel.center.x = self.view.center.x
        dashBoardLabel.text  = ""
        dashBoardLabel.font = UIFont.systemFontOfSize(self.dashBoardFontSize)
        dashBoardLabel.textColor = self.view.tintColor
        dashBoardLabel.numberOfLines = 0
        dashBoardLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(dashBoardLabel)
        
        //Animating Company Label
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [], animations:
            {
                self.companyFirstName.frame.origin.y = companyOrignY;
                self.companyLastName.frame.origin.y = companyOrignY
            }, completion: nil)
        
        //Animating DashBoard Label
        UIView.animateWithDuration(1.0, delay: 0.3, options:    UIViewAnimationOptions.CurveEaseOut, animations: {
            self.dashBoardLabel.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                
                //Once the label is completely invisible, set the text and fade it back in
                self.dashBoardLabel.text  = "DashBoards"
                
                // Fade in
                UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.dashBoardLabel.alpha = 1.0
                    }, completion: nil)
                
        })
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.5, target: self, selector: Selector("loadIntialViewOfTheApp"), userInfo: nil, repeats: false)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func loadIntialViewOfTheApp()
    {
        timer.invalidate()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewControllerWithIdentifier("home")
        self.presentViewController(myVC, animated: true, completion: nil)
    }
    
    func setSize() {
        
        let deviceType = UIDevice.currentDevice()
        
        if let path = NSBundle.mainBundle().pathForResource("Size", ofType: "plist"),
            dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                
                let iPhoneComponents = dict[deviceType.model] as? Dictionary<String, AnyObject>
                let componentSizes = iPhoneComponents!["SplashVC"] as? Dictionary<String, AnyObject>
                let size: Int = (componentSizes!["fontSize"] as? Int)!
                let fnameWidth: Int = (componentSizes!["firstNameWidth"] as? Int)!
                let lnameWidth: Int = (componentSizes!["lastNameWidth"] as? Int)!
                let dashWidth: Int = (componentSizes!["dashBoardWidth"] as? Int)!
                let dashFontSize: Int = (componentSizes!["dashBoardFontSize"] as? Int)!
                let height: Int = (componentSizes!["height"] as? Int)!
                
                self.fontSize = CGFloat(size)
                self.firstNameWidth = CGFloat(fnameWidth)
                self.lastNameWidth = CGFloat(lnameWidth)
                self.dashBoardWidth = CGFloat(dashWidth)
                self.dashBoardFontSize = CGFloat(dashFontSize)
                self.height = CGFloat(height)
                
              
        }
    }
    
}
