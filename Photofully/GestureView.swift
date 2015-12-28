//
//  GestureAnimationView.swift
//  Photofully
//
//  Created by Kenichiro Sato on 2015/12/13.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit


class GestureView: UIImageView {

    static private let width:CGFloat = 250.0
    static private let height:CGFloat = 250.0

    let rect = CGRectMake(Screen.WIDTH()/2 - GestureView.width/2,
        Screen.HEIGHT()/2 - GestureView.height/2, width, height)
    
    let delay:NSTimeInterval
    let duration:NSTimeInterval
    var totalDuration: NSTimeInterval {
        return delay + duration
    }
    
    init(name:String, delay:NSTimeInterval, duration:NSTimeInterval) {
        self.delay = delay
        self.duration = duration
        super.init(frame: rect)
        
        self.image = UIImage(named: name)
    }
    
    func show(parent:UIView) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            parent.addSubview(self)
            self.fadeInAndOut(self.duration)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
