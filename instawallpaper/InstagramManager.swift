//
//  InstagramManager.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/06/27.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation

public class InstagramManager {
    
    private enum Content {
        case FEED, SEARCH
    }

    
    static private let COUNT_PER_REQUEST = 50
    
    private var currentContent:Content?
    
    private var searchText:String?
    
    func roadPopularPictures(success:(([InstagramMedia], InstagramPaginationInfo?) -> Void), failure:InstagramFailureBlock) {
        InstagramEngine.sharedEngine().getPopularMediaWithSuccess(
            { (media, paginationInfo) in
                if let pictures = media as? [InstagramMedia] {
                    success(pictures, paginationInfo)
                }
            }, failure: failure)
    }
    
    func roadTopSeflFeed(success:(([InstagramMedia], InstagramPaginationInfo?) -> Void), failure:InstagramFailureBlock) {
        currentContent = Content.FEED
        roadSelfFeed(nil, success:success, failure: failure)
    }
    
    func roadTopSearchItems(text: String, success:(([InstagramMedia], InstagramPaginationInfo?) -> Void), failure:InstagramFailureBlock) {
        currentContent = Content.SEARCH
        searchText = text
        roadSearchItems(nil, success:success, failure: failure)
    }

    func roadNext(nextMaxId:String,
        success:(([InstagramMedia], InstagramPaginationInfo?) -> Void), failure:InstagramFailureBlock) {
        println("roedNext:")
        if let content = self.currentContent {
            switch(content) {
            case .FEED:
                roadSelfFeed(nextMaxId, success:success, failure: failure)
            case .SEARCH:
                roadSearchItems(nextMaxId, success:success, failure: failure)
            }
        }
    }
    
    /*
    func refresh(success:(([InstagramMedia], InstagramPaginationInfo) -> Void), failure:InstagramFailureBlock) {
        if let content = self.currentContent {
            switch(content) {
            case .FEED:
                roadTopSeflFeed(success, failure: failure)
            case .SEARCH:
                if let text = searchText {
                    roadTopSearchItems(text, success: success, failure: failure)
                }
            }
        }
    }
*/

    private func roadSelfFeed(maxId:String?,
        success:(([InstagramMedia], InstagramPaginationInfo?) -> Void), failure:InstagramFailureBlock) {
        InstagramEngine.sharedEngine().getSelfFeedWithCount(InstagramManager.COUNT_PER_REQUEST,
            maxId: maxId, success:
            { (media, paginationInfo) in
                if let pictures = media as? [InstagramMedia] {
                    success(pictures, paginationInfo)
                }
            }, failure: failure)
    }
    
    private func roadSearchItems(maxId:String?, success:(([InstagramMedia], InstagramPaginationInfo?) -> Void), failure:InstagramFailureBlock) {
        InstagramEngine.sharedEngine().getMediaWithTagName(searchText, count: InstagramManager.COUNT_PER_REQUEST,
            maxId: maxId, withSuccess:
            { (media, paginationInfo) in
                if let pictures = media as? [InstagramMedia] {
                    success(pictures, paginationInfo)
                }
            }, failure: failure)
    }
    
}