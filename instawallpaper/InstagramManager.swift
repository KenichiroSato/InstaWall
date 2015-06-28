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

    static let sharedInstance = InstagramManager()
    
    static private let COUNT_PER_REQUEST = 50
    
    private var paginationInfo: InstagramPaginationInfo? = nil
    
    private var currentContent:Content?
    
    private var searchText:String?
    
    private func resetPaginationInfo() {
        paginationInfo = nil
    }
    
    func roadPopularPictures(success:(([InstagramMedia]) -> Void), failure:InstagramFailureBlock) {
        InstagramEngine.sharedEngine().getPopularMediaWithSuccess(
            { (media, paginationInfo) in
                self.paginationInfo = paginationInfo
                if let pictures = media as? [InstagramMedia] {
                    success(pictures)
                }
            }, failure: failure)
    }
    
    func roadTopSeflFeed(success:(([InstagramMedia]) -> Void), failure:InstagramFailureBlock) {
        resetPaginationInfo()
        currentContent = Content.FEED
        roadSelfFeed(success, failure: failure)
    }
    
    func roadTopSearchItems(text: String, success:(([InstagramMedia]) -> Void), failure:InstagramFailureBlock) {
        resetPaginationInfo()
        currentContent = Content.SEARCH
        searchText = text
        roadSearchItems(success, failure: failure)
    }

    func roadNext(success:(([InstagramMedia]) -> Void), failure:InstagramFailureBlock) {
        if (self.paginationInfo?.nextMaxId == nil) {
            print("already bottom")
            return
        }
        print("roedNext:")
        if let content = self.currentContent {
            switch(content) {
            case .FEED:
                roadSelfFeed(success, failure: failure)
            case .SEARCH:
                roadSearchItems(success, failure: failure)
            }
        }
    }

    private func roadSelfFeed(success:(([InstagramMedia]) -> Void), failure:InstagramFailureBlock) {
        InstagramEngine.sharedEngine().getSelfFeedWithCount(InstagramManager.COUNT_PER_REQUEST,
            maxId: self.paginationInfo?.nextMaxId, success:
            { (media, paginationInfo) in
                self.paginationInfo = paginationInfo
                if let pictures = media as? [InstagramMedia] {
                    success(pictures)
                }
            }, failure: failure)
    }
    
    private func roadSearchItems(success:(([InstagramMedia]) -> Void), failure:InstagramFailureBlock) {
        InstagramEngine.sharedEngine().getMediaWithTagName(searchText, count: InstagramManager.COUNT_PER_REQUEST,
            maxId: self.paginationInfo?.nextMaxId, withSuccess:
            { (media, paginationInfo) in
                self.paginationInfo = paginationInfo
                if let pictures = media as? [InstagramMedia] {
                    success(pictures)
                }
            }, failure: failure)
    }
    
}