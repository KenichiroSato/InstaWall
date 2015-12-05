//
//  InstagramManager.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/06/27.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation
import InstagramKit

typealias SuccessLoadBlock = (([InstagramMedia], InstagramPaginationInfo?) -> Void)

public class InstagramManager {
    
    static private let URL_SCHEME = "instagram://media?id="
    
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
        let text = searchText.removeSpace()
        InstagramEngine.sharedEngine().getMediaWithTagName(text, count: InstagramManager.COUNT_PER_REQUEST,
            maxId: maxId, withSuccess:
            { (media, paginationInfo) in
                if let pictures = media as? [InstagramMedia] {
                    success(pictures, paginationInfo)
                }
            }, failure: failure)
    }
    
    /// - returns: true if sucess. Otherwise return false
    class func openInstagramApp(mediaId:String) -> Bool {
        if let url = NSURL(string: InstagramManager.URL_SCHEME + mediaId) {
            return UIApplication.sharedApplication().openURL(url)
        } else {
            return false
        }
    }
    
}