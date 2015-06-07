//
//  DebugUtil.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/06/07.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation

public class TimeTracker {
    
    let tag: String
    var startDate: NSDate?
    
    init(tag: String) {
        self.tag = tag
    }
    
    public func start() {
        startDate = NSDate()
    }
    
    public func finish() {
        let endDate =  NSDate()
        if let start = startDate {
            var time = Float(endDate.timeIntervalSinceDate(start))
            println(tag + ": time=" + time.description)
        }
    }
    
}