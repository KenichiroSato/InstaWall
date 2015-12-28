//
//  FeedContentLoader.swift
//  Photofully
//
//  Created by Kenichiro Sato on 2015/11/29.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class FeedContentLoader: ContentLoader {

    override func doLoad() {
        instagramManager.roadSelfFeed(paginationInfo, success:successBlock, failure: failureBlock)
    }

}
