//
//  Gesture.swift
//  instawallpaper
//
//  Created by 2ndDisplay on 2015/12/10.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class GestureConteiner {
    
    let DURATION_TEXT: NSTimeInterval = 1.3
    let DURATION_VIEW: NSTimeInterval = 0.5
    let DELAY: NSTimeInterval = 0.7
    
    var animations: [GestureView] = []
    
    var minDelay: NSTimeInterval {
        guard animations.count > 0 else {
            return 0.0
        }
        return  animations.reduce(animations[0], combine: {
            $0.delay < $1.delay ? $0 : $1}).delay
    }
    
    var totalDuration: NSTimeInterval {
        guard animations.count > 0 else {
            return 0.0
        }
        return animations.reduce(animations[0], combine: {
            $0.totalDuration > $1.totalDuration ? $0 : $1}).totalDuration
    }

    
    let shadow:UIView = UIView()
    
    private var ud: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    init() {
        shadow.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    //must be overridden by subclass
    func userDefaultKey() -> String {
        fatalError("must be overridden by subclass")
    }

    func shouldShow() -> Bool {
        return ud.boolForKey(userDefaultKey())
    }
    
    func gestureHasDone() {
        ud.setBool(false, forKey: userDefaultKey())
    }
    
    func resetFlag() {
        ud.setBool(true, forKey: userDefaultKey())
    }
    
    func show(parentView: UIView) {
        showShadow(parentView)
        animations.forEach({
            $0.show(parentView)
        })
    }
    
    private func showShadow(parent:UIView) {
        shadow.frame = parent.frame
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(minDelay * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            parent.addSubview(self.shadow)
            self.shadow.fadeInAndOut(self.totalDuration)
        }
    }
    
}


class LeftToRight: GestureConteiner {
    
    override init() {
        super.init()
        animations += [
            GestureView(name: "instructionBack", delay: 0, duration: DURATION_TEXT),
            GestureView(name: "instructionFingerLeft", delay: 0, duration: DURATION_VIEW),
            GestureView(name: "instructionFingerRight", delay: DELAY, duration: DURATION_VIEW),
            GestureView(name: "instructionHorizontalLine", delay: DELAY, duration: DURATION_VIEW)
        ]
    }
    
    override func userDefaultKey() -> String {
        return UserDefaultKey.SHOULD_SHOW_GESTURE_LEFT_TO_RIGHT
    }
}

class RightToLeft: GestureConteiner {
    
    override init() {
        super.init()
        animations += [
            GestureView(name: "instructionOpen", delay: 0, duration: DURATION_TEXT),
            GestureView(name: "instructionFingerRight", delay: 0, duration: DURATION_VIEW),
            GestureView(name: "instructionFingerLeft", delay: DELAY, duration: DURATION_VIEW),
            GestureView(name: "instructionHorizontalLine", delay: DELAY, duration: DURATION_VIEW)
        ]
    }
    
    override func userDefaultKey() -> String {
        return UserDefaultKey.SHOULD_SHOW_GESTURE_RIGHT_TO_LEFT
    }
}

class DownToUp: GestureConteiner {
    
    override init() {
        super.init()
        animations += [
            GestureView(name: "instructionScroll", delay: 0, duration: DURATION_TEXT),
            GestureView(name: "instructionFingerDown", delay: 0, duration: DURATION_VIEW),
            GestureView(name: "instructionFingerUp", delay: DELAY, duration: DURATION_VIEW),
        ]
    }
    
    override func userDefaultKey() -> String {
        return UserDefaultKey.SHOULD_SHOW_GESTURE_DOWN_TO_UP
    }
}