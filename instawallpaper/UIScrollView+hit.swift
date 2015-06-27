//
//  UIScrollView+hit.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/06/27.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation

extension UIScrollView {
    
    func isHitBottom() -> Bool {
        if (self.contentOffset.y >= (self.contentSize.height - self.frame.size.height)) {
            return true
        } else {
            return false
        }
    }
    
    func isHitTop() -> Bool {
        if (self.contentOffset.y < 0){
            return true
        } else {
            return false
        }
    }
}