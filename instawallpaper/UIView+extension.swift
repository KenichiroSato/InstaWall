//
//  UIView+extension.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/08/28.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func fadeInAndOut() {
        let fadeInInterval: NSTimeInterval = 0.3
        let showInterval: NSTimeInterval = 0.5
        let fadeOutInterval: NSTimeInterval = 1.0
        self.alpha = 0
        self.hidden = false
        UIView.animateWithDuration( fadeInInterval, animations: {self.alpha = 1}
            , completion: { (finished: Bool) in
                UIView.animateWithDuration(fadeOutInterval, delay: showInterval, options: [],
                    animations: {self.alpha = 0}, completion: nil)
        })
    }
}