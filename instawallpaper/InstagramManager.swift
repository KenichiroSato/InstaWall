//
//  InstagramManager.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/06/27.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation

typealias SuccessLoadBlock = (([InstagramMedia], InstagramPaginationInfo?) -> Void)

public class InstagramManager {
    
    static private let COUNT_PER_REQUEST = 50
    
    func roadPopular(success:SuccessLoadBlock, failure:InstagramFailureBlock) {
        InstagramEngine.sharedEngine().getPopularMediaWithSuccess(
            { (media, paginationInfo) in
                if let pictures = media as? [InstagramMedia] {
                    success(pictures, paginationInfo)
                }
            }, failure: failure)
    }
    
    func roadSelfFeed(maxId:String?, success:SuccessLoadBlock, failure:InstagramFailureBlock) {
        InstagramEngine.sharedEngine().getSelfFeedWithCount(InstagramManager.COUNT_PER_REQUEST,
            maxId: maxId, success:
            { (media, paginationInfo) in
                if let pictures = media as? [InstagramMedia] {
                    success(pictures, paginationInfo)
                }
            }, failure: failure)
    }
    
    func roadSearchItems(searchText:String, maxId:String?,
        success:SuccessLoadBlock, failure:InstagramFailureBlock) {
        InstagramEngine.sharedEngine().getMediaWithTagName(searchText, count: InstagramManager.COUNT_PER_REQUEST,
            maxId: maxId, withSuccess:
            { (media, paginationInfo) in
                if let pictures = media as? [InstagramMedia] {
                    success(pictures, paginationInfo)
                }
            }, failure: failure)
    }
    
}