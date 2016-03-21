//
//  RVC.swift
//  NewPro
//
//  Created by Ashok on 3/17/16.
//  Copyright © 2016 Ashok. All rights reserved.
//

import UIKit

class RVC: UICollectionViewController {


    
    var photos = Photo.allPhotos()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! HomeScreenCell
        cell.photo = photos[indexPath.item]
        
        UIColor.lightGrayColor().CGColor
        cell.viewWithTag(1001)?.layer.masksToBounds = false
        cell.viewWithTag(1001)?.layer.shadowColor = UIColor.whiteColor().CGColor
        cell.viewWithTag(1001)?.layer.shadowOpacity = 0.2
        cell.viewWithTag(1001)?.layer.shadowRadius = 2.0
        cell.viewWithTag(1001)?.layer.shadowOffset = CGSizeMake(0, 1)
        cell.viewWithTag(1001)?.layer.shouldRasterize = true
        cell.viewWithTag(1001)?.layer.cornerRadius = 5.0
        cell.viewWithTag(1001)?.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.viewWithTag(1001)?.layer.borderWidth = 1.0
        cell.viewWithTag(1001)?.layer.shadowPath = UIBezierPath(rect: cell.bounds).CGPath
        
//        cell.viewWithTag(1001)?.layer.shadowOffset = CGSizeMake(1, 1)
//        cell.viewWithTag(1001)?.layer.shadowColor = UIColor.whiteColor().CGColor
//        cell.viewWithTag(1001)?.layer.shadowRadius = 3.0
//        cell.viewWithTag(1001)?.layer.shadowOpacity = 0.80
//        cell.viewWithTag(1001)?.layer.borderColor = UIColor.lightGrayColor().CGColor
//        cell.viewWithTag(1001)?.layer.borderWidth = 1.0
//        cell.viewWithTag(1001)?.layer.shouldRasterize = true
//        cell.viewWithTag(1001)?.layer.shadowPath = UIBezierPath(rect: cell.bounds).CGPath

        return cell

    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("dashboard") as UIViewController;
        
        self.navigationController?.pushViewController(vc, animated: true);
    }
   
}

extension RVC: UICollectionViewDelegateFlowLayout{

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        var collectionViewSize = collectionView.frame.size
        print("collectionView.frame.size = \(collectionView.frame.size)")
        collectionViewSize.width = (collectionViewSize.width * 32.5)/100// Display Three elements in a row.
        collectionViewSize.height = collectionViewSize.height/5.0
        print("modified collectionView.frame.size = \(collectionViewSize)")
        return collectionViewSize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
       return (collectionView.frame.size.height * 5)/100
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: (collectionView.frame.size.height * 5)/100, left: (collectionView.frame.size.width * 12)/100, bottom: 0, right: (collectionView.frame.size.width * 12)/100)
    }
}
