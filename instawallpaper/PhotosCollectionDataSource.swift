//
//  PhotosCollectionDataSource.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/11/28.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit
import InstagramKit

protocol PhotosLoadDelegate {
    func onLoadSuccess()
    func onLoadFail()
}

class PhotosCollectionDataSource: NSObject {

    private enum Content {
        case POPULAR, FEED, SEARCH
    }
    
    var pictureArray: [InstagramMedia] = []
    private var paginationInfo: InstagramPaginationInfo? = nil
    private var currentContent:Content = .POPULAR
    private var searchText:String?
    private let instagramManager = InstagramManager()
    var photosLoadDelegate: PhotosLoadDelegate?

    lazy private var successBlock: SuccessLoadBlock
    = {[unowned self] (pictures, paginationInfo) in
        self.paginationInfo = paginationInfo
        self.pictureArray += pictures
        self.photosLoadDelegate?.onLoadSuccess()
    }
    
    lazy private var failureBlock:InstagramFailureBlock  = {[unowned self] error, statusCode in
        self.clearData()
        self.photosLoadDelegate?.onLoadFail()
    }
 
    private func resetPaginationInfo() {
        paginationInfo = nil
    }
    
    func roadTopPopular() {
        roadPopular(successBlock, failure: failureBlock)
    }
    
    private func roadPopular(success:SuccessLoadBlock, failure:InstagramFailureBlock) {
        currentContent = .POPULAR
        instagramManager.roadPopular(success, failure:failure)
    }
    
    func roadTopSearchItems(text: String) {
        roadSearchItems(text, success: successBlock, failure: failureBlock)
    }
    
    private func roadSearchItems(text: String, success:SuccessLoadBlock, failure:InstagramFailureBlock) {
        currentContent = .SEARCH
        searchText = text
        instagramManager.roadSearchItems(text, maxId: paginationInfo?.nextMaxId, success:success, failure:failure)
    }
    
    func roadTopSelfFeed() {
        roadSelfFeed(successBlock, failure: failureBlock)
    }
    
    private func roadSelfFeed(success:SuccessLoadBlock, failure:InstagramFailureBlock) {
        currentContent = .FEED
        instagramManager.roadSelfFeed(paginationInfo?.nextMaxId, success:success, failure: failure)
    }
    
    func isBottom() -> Bool {
        if let _ = paginationInfo?.nextMaxId {
            return false
        } else {
            return true
        }
    }
    
    func roadNext() {
        guard let _ = paginationInfo?.nextMaxId else {
            return
        }
        switch(currentContent) {
        case .POPULAR:
            //nop
            break
        case .FEED:
            roadSelfFeed(successBlock, failure: failureBlock)
        case .SEARCH:
            if let text = searchText {
                roadSearchItems(text, success:successBlock, failure: failureBlock)
            }
        }
    }
    
    func refresh() {
        paginationInfo = nil
        let success:SuccessLoadBlock = {[unowned self] (pictures, paginationInfo) in
            self.pictureArray.removeAll(keepCapacity: false)
            self.successBlock(pictures, paginationInfo)
        }
        let failure:InstagramFailureBlock = {[unowned self] error, statusCode in
            self.failureBlock(error, statusCode)
        }
        
        switch(currentContent) {
        case .POPULAR:
            roadPopular(success, failure: failure)
        case .FEED:
            roadSelfFeed(success, failure: failure)
        case .SEARCH:
            if let text = searchText {
                roadSearchItems(text, success:success, failure: failure)
            }
        }
    }
    
    func clearData() {
        resetPaginationInfo()
        pictureArray.removeAll(keepCapacity: false)
    }

}
