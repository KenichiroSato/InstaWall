//
//  GestureAnimationView.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/12/13.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit


class GestureAnimationView: UIImageView {

    let width = 320.0
    let height = 320.0
    let gestureAnimationDelay:NSTimeInterval
    let gestureAnimationDuration:NSTimeInterval
    
    init(frame: CGRect, name:String, delay:NSTimeInterval, duration:NSTimeInterval) {
        gestureAnimationDelay = delay
        gestureAnimationDuration = duration
        super.init(frame: frame)
        
        self.image = UIImage(named: name)
    }
    
    func show() {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(gestureAnimationDelay * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.fadeInAndOut(self.gestureAnimationDuration)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
