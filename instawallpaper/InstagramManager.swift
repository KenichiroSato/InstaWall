//
//  InstagramManager.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/06/27.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation

public class InstagramManager {

    static let sharedInstance = InstagramManager()
    
    private var paginationInfo: InstagramPaginationInfo? = nil
    
    func roadSelfFeed(success:(([InstagramMedia]) -> Void), failure:InstagramFailureBlock) {
        InstagramEngine.sharedEngine().getSelfFeedWithCount(50,
            maxId: self.paginationInfo?.nextMaxId, success:
            { (media, paginationInfo) in
                self.paginationInfo = paginationInfo
                if let pictures = media as? [InstagramMedia] {
                    success(pictures)
                }
            }, failure: failure)
    }
    
    func roedNextSelfFeed(success:(([InstagramMedia]) -> Void), failure:InstagramFailureBlock) {
        if (self.paginationInfo?.nextMaxId == nil) {
            println("already bottom")
            return
        }
        println("roedNextSelfFeed:")
        InstagramEngine.sharedEngine().getSelfFeedWithCount(50,
            maxId: self.paginationInfo?.nextMaxId, success:
            { (media, paginationInfo) in
                self.paginationInfo = paginationInfo
                if let pictures = media as? [InstagramMedia] {
                    success(pictures)
                }
            }, failure: failure)
    }

}