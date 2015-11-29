//
//  SearchContentLoader.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/11/29.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class SearchContentLoader: ContentLoader {

    var searchText:String?

    override func loadContent() {
        guard let text = searchText else {
            return
        }
        instagramManager.roadSearchItems(text, maxId: paginationInfo?.nextMaxId,
            success:successBlock, failure:failureBlock)
    }

}
