//
//  ContentLoader.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/11/28.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class ContentLoader: NSObject {

    let MAX_RETRY_COUNT = 3
    
    var pictureArray: [Picture] = []
    var paginationInfo: String? = nil
    let instagramManager = InstagramManager()
    var photosLoadDelegate: PhotosLoadDelegate?
    var isLoading = false
    var retryCount = 0
    var shouldRetry: Bool {
        return (retryCount < MAX_RETRY_COUNT)
    }
    
    lazy var successBlock: SuccessLoadBlock
    = {[unowned self] (pictures, paginationInfo) in
        self.paginationInfo = paginationInfo
        self.pictureArray += pictures
        self.photosLoadDelegate?.onLoadSuccess?()
        self.isLoading = false
        self.retryCount = 0
    }
    
    lazy var failureBlock: (NSError!, Int) -> Void = {[unowned self] error, statusCode in
        if (self.shouldRetry) {
            self.retryCount++
            self.doLoad()
            return
        }
        self.clearData()
        self.photosLoadDelegate?.onLoadFail?()
        self.isLoading = false
        self.retryCount = 0
    }

    func clearData() {
        resetPaginationInfo()
        pictureArray.removeAll(keepCapacity: false)
    }
    
    private func resetPaginationInfo() {
        paginationInfo = nil
    }
    
    func loadContent() {
        if (isLoading) {
            print("already loading")
            return
        }
        isLoading = true
        doLoad()
    }
    
    func doLoad() {
        fatalError("must be overridden")
    }
}
