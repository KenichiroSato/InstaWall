//
//  ContentLoader.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/11/28.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit
import InstagramKit

class ContentLoader: NSObject {

    var pictureArray: [InstagramMedia] = []
    var paginationInfo: InstagramPaginationInfo? = nil
    let instagramManager = InstagramManager()
    var photosLoadDelegate: PhotosLoadDelegate?
    
    lazy var successBlock: SuccessLoadBlock
    = {[unowned self] (pictures, paginationInfo) in
        self.paginationInfo = paginationInfo
        self.pictureArray += pictures
        self.photosLoadDelegate?.onLoadSuccess()
    }
    
    lazy var failureBlock:InstagramFailureBlock  = {[unowned self] error, statusCode in
        self.clearData()
        self.photosLoadDelegate?.onLoadFail()
    }

    func clearData() {
        resetPaginationInfo()
        pictureArray.removeAll(keepCapacity: false)
    }
    
    private func resetPaginationInfo() {
        paginationInfo = nil
    }
    
    func loadContent() {
        fatalError("must be overridden")
    }
    
}
