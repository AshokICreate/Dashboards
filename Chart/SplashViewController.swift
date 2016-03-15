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
    
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.mainScreen().bounds
        let companyOrignX = (screenSize.size.width*35)/100
        let companyOrignY = ((screenSize.size.height*30)/100)
        
        companyFirstName = UILabel(frame: CGRect(x: companyOrignX, y: screenSize.origin.y, width: 103, height: 50))
        companyFirstName.text  = "Metric"
        companyFirstName.font = UIFont.boldSystemFontOfSize(35)
        companyFirstName.numberOfLines = 0
        companyFirstName.adjustsFontSizeToFitWidth = false
        self.view .addSubview(companyFirstName)
        
        let xPositonForSecondLabel = companyFirstName.frame.origin.x + companyFirstName.frame.width
        
        companyLastName = UILabel(frame: CGRect(x: xPositonForSecondLabel , y: screenSize.size.height-50, width: 117, height: 50))
        companyLastName.text  = "Stream"
        companyLastName.font = UIFont.boldSystemFontOfSize(35)
        companyLastName.numberOfLines = 0
        companyLastName.adjustsFontSizeToFitWidth = false
        self.view.addSubview(companyLastName)
        
        //DashBoard Label
        let dashBoardOriginX = (screenSize.size.width*40)/100
        let dashBoardOriginY = ((screenSize.size.height*34)/100)
        
        dashBoardLabel = UILabel(frame: CGRect(x: dashBoardOriginX , y: dashBoardOriginY, width: 133, height: 50))
        dashBoardLabel.text  = ""
        dashBoardLabel.font = UIFont.systemFontOfSize(23.0)
        dashBoardLabel.textColor = self.view.tintColor
        dashBoardLabel.numberOfLines = 0
        dashBoardLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(dashBoardLabel)
        
        //Animating Company Label
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [], animations:
            {
                self.companyFirstName.frame = CGRect(x: companyOrignX, y: companyOrignY, width: 103, height: 50)
                self.companyLastName.frame = CGRect(x: xPositonForSecondLabel , y: companyOrignY, width: 117, height: 50)
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
    
}
