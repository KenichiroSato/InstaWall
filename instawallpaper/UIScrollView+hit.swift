//
//  UIScrollView+hit.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/06/27.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation

extension UIScrollView {
    
    static private let PULL_TO_REFRESH_TRIGGER: CGFloat = -160.0
    static private let DEFAULT_CONTENT_OFFSET_Y: CGFloat = -44.0
    
    // return true when scroll view hits the bottom
    func isHitBottom() -> Bool {
        if (self.contentOffset.y >= (self.contentSize.height - self.frame.size.height)) {
            return true
        } else {
            return false
        }
    }
    
    // return true when scroll view is going to hits the bottom soon
    func isCloseToBottom() -> Bool {
        if (self.contentOffset.y >= (self.contentSize.height - self.frame.size.height*2)) {
            return true
        } else {
            return false
        }
    }
    
    func isHitTop() -> Bool {
        if (self.contentOffset.y == UIScrollView.DEFAULT_CONTENT_OFFSET_Y){
            return true
        } else {
            return false
        }
    }
    
    func shouldPullToRefresh() -> Bool {
        if (self.contentOffset.y < UIScrollView.PULL_TO_REFRESH_TRIGGER){
            return true
        } else {
            return false
        }
    }
}