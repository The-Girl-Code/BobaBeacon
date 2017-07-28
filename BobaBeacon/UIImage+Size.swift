//
//  UIImage+Size.swift
//  BobaBeacon
//
//  Created by TheGirlCode on 6/27/17.
//  Copyright © 2017 The Girl Code. All rights reserved.
//

import UIKit

extension UIImage {
    var aspectHeight: CGFloat {
        let heightRatio = size.height / 736
        let widthRatio = size.width / 414
        let aspectRatio = fmax(heightRatio, widthRatio)
        
        return size.height / aspectRatio
    }
}
