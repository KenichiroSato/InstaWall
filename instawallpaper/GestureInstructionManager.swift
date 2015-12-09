//
//  GestureInstructionManager.swift
//  instawallpaper
//
//  Created by 2ndDisplay on 2015/12/09.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class GestureInstructionManager: NSObject {

    let leftToRight = LeftToRight()
    let rightToLeft = RightToLeft()
    let downToTop = DownToUp()
    let gestures: [Gesture]
    
    override init() {
        gestures = [downToTop, leftToRight, rightToLeft]
        super.init()
    }
    
    func gestureToBeShown() -> Gesture? {
        return gestures.filter({$0.shouldShow()}).first
    }
    
    func doneRightToLeft() {
        rightToLeft.gestureHasDone()
    }
    
    func doneLeftToRight() {
        leftToRight.gestureHasDone()
    }
    
    func doneDownToUp() {
        downToTop.gestureHasDone()
    }
}

class Gesture {
    
    private var ud: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    //must be overridden by subclass
    func userDefaultKey() -> String {
        fatalError("must be overridden by subclass")
    }
    
    //must be overridden by subclass
    func show(vc: UIViewController) {
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
}

class LeftToRight: Gesture {
    
    override func userDefaultKey() -> String {
        return UserDefaultKey.SHOULD_SHOW_GESTURE_LEFT_TO_RIGHT
    }
    
    override func show(vc: UIViewController) {
        UIAlertController.show("leftToRight",
            message: nil, forVC: vc, handler: nil)
    }
}

class RightToLeft: Gesture {
    
    override func userDefaultKey() -> String {
        return UserDefaultKey.SHOULD_SHOW_GESTURE_RIGHT_TO_LEFT
    }
    
    override func show(vc: UIViewController) {
        UIAlertController.show("rightToLeft",
            message: nil, forVC: vc, handler: nil)
    }
}

class DownToUp: Gesture {
    
    override func userDefaultKey() -> String {
        return UserDefaultKey.SHOULD_SHOW_GESTURE_DOWN_TO_UP
    }
    
    override func show(vc: UIViewController) {
        UIAlertController.show("downToUp",
            message: nil, forVC: vc, handler: nil)
    }
}