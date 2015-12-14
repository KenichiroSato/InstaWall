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
    let gestures: [GestureConteiner]
    
    override init() {
        gestures = [downToTop, leftToRight, rightToLeft]
        super.init()
    }
    
    func gestureToBeShown() -> GestureConteiner? {
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

