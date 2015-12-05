//
//  Picture.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/12/05.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class Picture: NSObject {

    let id: String
    
    let thumbnailURL: NSURL
    
    let imageFrameSize: CGSize
    
    let imageURL: NSURL
    
    var thumbnail: UIImage?

    var topColor: UIColor = UIColor.blackColor()
    
    var bottomColor: UIColor = UIColor.blackColor()
    
    init(id: String, thumbnailURL: NSURL, size: CGSize, imageURL: NSURL) {
        self.id = id
        self.thumbnailURL = thumbnailURL
        self.imageFrameSize = size
        self.imageURL = imageURL
        super.init()
    }
    
    var fullScreenHeight: CGFloat {
        return Screen.WIDTH() * imageFrameSize.height / imageFrameSize.width
    }
    
}
