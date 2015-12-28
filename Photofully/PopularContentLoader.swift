//
//  PopularContenteLoader.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/11/29.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class PopularContentLoader: ContentLoader {

    override func doLoad() {
        instagramManager.roadPopular(successBlock, failure:failureBlock)
    }
    
}
