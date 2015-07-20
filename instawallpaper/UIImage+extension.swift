//
//  UIImage+extension.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/07/20.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation

extension UIImage {

    class func named(name:String, size:CGSize) -> UIImage? {
        if let image = UIImage(named: name) {
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            let ratio: CGFloat = size.width / image.size.width
            image.drawInRect(CGRectMake(0, 0, size.width, ratio * image.size.height))
            let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return newImage
        }
        return nil
    }
    
}