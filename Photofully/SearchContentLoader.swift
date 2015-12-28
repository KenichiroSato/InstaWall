//
//  SearchContentLoader.swift
//  Photofully
//
//  Created by Kenichiro Sato on 2015/11/29.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class SearchContentLoader: ContentLoader {

    var searchText:String?

    override func doLoad() {
        guard let text = searchText else {
            return
        }
        instagramManager.roadSearchItems(text, maxId: paginationInfo,
            success:successBlock, failure:failureBlock)
    }

}
