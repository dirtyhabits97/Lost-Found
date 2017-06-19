//
//  UIImage+helpers.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 6/19/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(width: CGFloat) -> UIImage?{
        let scale = width / self.size.width
        let height = self.size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
