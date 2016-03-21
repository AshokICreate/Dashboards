//
//  RoundedCornersView.swift
//  NewPro
//
//  Created by Ashok on 3/18/16.
//  Copyright © 2016 Ashok. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornersView: UIView {
  
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
    }
  }
  
}
