//
//  FeedContentLoader.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/11/29.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class FeedContentLoader: ContentLoader {

    override func loadContent() {
        instagramManager.roadSelfFeed(paginationInfo?.nextMaxId, success:successBlock, failure: failureBlock)
    }

}
