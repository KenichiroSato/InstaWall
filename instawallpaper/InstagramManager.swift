//
//  InstagramManager.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/06/27.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation
import InstagramKit

typealias SuccessLoadBlock = (([Picture], String?) -> Void)

public class InstagramManager {
    
    static private let URL_SCHEME = "instagram://media?id="
    
    static private let COUNT_PER_REQUEST = 50
    
    func roadPopular(success:SuccessLoadBlock, failure:InstagramFailureBlock) {
        InstagramEngine.sharedEngine().getPopularMediaWithSuccess(
            { (media, paginationInfo) in
                if let pictures = media as? [InstagramMedia] {
                    let pics:[Picture] = pictures.map{self.createPicture($0)}
                    let pageInfo = (paginationInfo != nil) ? paginationInfo.nextMaxId : nil
                    success(pics, pageInfo)
                }
            }, failure: failure)
    }
    
    func roadSelfFeed(maxId:String?, success:SuccessLoadBlock, failure:InstagramFailureBlock) {
        InstagramEngine.sharedEngine().getSelfFeedWithCount(InstagramManager.COUNT_PER_REQUEST,
            maxId: maxId, success:
            { (media, paginationInfo) in
                if let pictures = media as? [InstagramMedia] {
                    let pics:[Picture] = pictures.map{self.createPicture($0)}
                    let pageInfo = (paginationInfo != nil) ? paginationInfo.nextMaxId : nil
                    success(pics, pageInfo)
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
                    let pics:[Picture] = pictures.map{self.createPicture($0)}
                    let pageInfo = (paginationInfo != nil) ? paginationInfo.nextMaxId : nil
                    success(pics, pageInfo)
                }
            }, failure: failure)
    }
    
    private func createPicture(media:InstagramMedia) -> Picture {
        return Picture(id: media.Id, thumbnailURL: media.thumbnailURL, size: media.standardResolutionImageFrameSize, imageURL: media.standardResolutionImageURL)
    }
    
    /// - returns: true if sucess. Otherwise return false
    class func openInstagramApp(mediaId:String) -> Bool {
        guard !mediaId.isEmpty else {
            return false
        }
        
        if let url = NSURL(string: InstagramManager.URL_SCHEME + mediaId) {
            return UIApplication.sharedApplication().openURL(url)
        } else {
            return false
        }
    }
    
}