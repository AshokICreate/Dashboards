//
//  HomeScreenModel.swift
//  NewPro
//
//  Created by Ashok on 3/18/16.
//  Copyright © 2016 Ashok. All rights reserved.
//

import UIKit

class Photo {
    
    class func allPhotos() -> [Photo] {
        var photos = [Photo]()
        if let URL = NSBundle.mainBundle().URLForResource("Photos", withExtension: "plist") {
            if let photosFromPlist = NSArray(contentsOfURL: URL) {
                for dictionary in photosFromPlist {
                    let photo = Photo(dictionary: dictionary as! NSDictionary)
                    photos.append(photo)
                }
            }
        }
        return photos
    }
    
    var caption: String
    var image: UIImage
    
    init(caption: String, image: UIImage) {
        self.caption = caption
        self.image = image
    }
    
    convenience init(dictionary: NSDictionary) {
        let caption = dictionary["Caption"] as? String
        let photo = dictionary["Photo"] as? String
        let image = UIImage(named: photo!)?.decompressedImage
        self.init(caption: caption!, image: image!)
    }
    
    func heightForComment(font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: caption).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
    
}
