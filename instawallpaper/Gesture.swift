//
//  Gesture.swift
//  instawallpaper
//
//  Created by 2ndDisplay on 2015/12/10.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class Gesture {
    
    private var ud: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    //must be overridden by subclass
    func userDefaultKey() -> String {
        fatalError("must be overridden by subclass")
    }
    
    //must be overridden by subclass
    func textImageName() -> String {
        fatalError("must be overridden by subclass")
    }
    
    //must be overridden by subclass
    func firstImageName() -> String {
        fatalError("must be overridden by subclass")
    }
    
    //must be overridden by subclass
    func secondImageName() -> String {
        fatalError("must be overridden by subclass")
    }
    
    //must be overridden by subclass
    func secondImageName2() -> String? {
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
    
    func show(vc: UIViewController) {
        let width: CGFloat = 250
        let height: CGFloat = 250
        let rect = CGRectMake(Screen.WIDTH()/2 - width/2, Screen.HEIGHT()/2 - height/2, width, height)
        
        let textImage = UIImageView()
        textImage.frame = rect
        textImage.image = UIImage(named: textImageName())
        vc.view.addSubview(textImage)
        textImage.fadeInAndOut(0.9)
        
        let imageView = UIImageView()
        imageView.frame = rect
        imageView.image = UIImage(named: firstImageName())
        vc.view.addSubview(imageView)
        imageView.fadeInAndOut(0.3)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.6 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            let imageView2 = UIImageView()
            imageView2.frame = rect
            imageView2.image = UIImage(named: self.secondImageName())
            vc.view.addSubview(imageView2)
            imageView2.fadeInAndOut(0.3)
            
            if let name2 = self.secondImageName2() {
                let imageView3 = UIImageView()
                imageView3.frame = rect
                imageView3.image = UIImage(named: name2)
                vc.view.addSubview(imageView3)
                imageView3.fadeInAndOut(0.3)
            }
        }
    }
}

class LeftToRight: Gesture {
    
    override func userDefaultKey() -> String {
        return UserDefaultKey.SHOULD_SHOW_GESTURE_LEFT_TO_RIGHT
    }
    
    override func textImageName() -> String {
        return "instructionBack"
    }
    
    override func firstImageName() -> String {
        return "instructionFingerLeft"
    }
    
    override func secondImageName() -> String {
        return "instructionFingerRight"
    }

    override func secondImageName2() -> String? {
        return "instructionHorizontalLine"
    }
}

class RightToLeft: Gesture {
    
    override func userDefaultKey() -> String {
        return UserDefaultKey.SHOULD_SHOW_GESTURE_RIGHT_TO_LEFT
    }
    
    override func textImageName() -> String {
        return "instructionOpen"
    }
    
    override func firstImageName() -> String {
        return "instructionFingerRight"
    }
    
    override func secondImageName() -> String {
        return "instructionFingerLeft"
    }
    
    override func secondImageName2() -> String? {
        return "instructionHorizontalLine"
    }
}

class DownToUp: Gesture {
    
    override func userDefaultKey() -> String {
        return UserDefaultKey.SHOULD_SHOW_GESTURE_DOWN_TO_UP
    }
    
    override func textImageName() -> String {
        return "instructionScroll"
    }
    
    override func firstImageName() -> String {
        return "instructionFingerDown"
    }
    
    override func secondImageName() -> String {
        return "instructionFingerUp"
    }
    
    override func secondImageName2() -> String? {
        return nil
    }

}