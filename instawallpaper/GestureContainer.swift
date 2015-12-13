//
//  Gesture.swift
//  instawallpaper
//
//  Created by 2ndDisplay on 2015/12/10.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class GestureConteiner {
    
    let DURATION_TEXT:NSTimeInterval = 1.3
    let DURATION_VIEW:NSTimeInterval = 0.4
    let DELAY: NSTimeInterval = 0.6
    
    var animations: [GestureView] = []
    
    private var ud: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
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
        animations.forEach({
            $0.show(parentView)
        })
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