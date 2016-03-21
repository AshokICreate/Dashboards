//
//  HomeScreenCell.swift
//  NewPro
//
//  Created by Ashok on 3/18/16.
//  Copyright © 2016 Ashok. All rights reserved.
//

import UIKit

class HomeScreenCell: UICollectionViewCell {


    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var captionLabel: UILabel!
    
    var photo: Photo? {
        didSet {
            if let photo = photo {
                imageView.image = photo.image
                captionLabel.text = photo.caption
            }
        }
    }
    
}
