//
//  FullScreenPictureCell.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/11/15.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class FullScreenPictureCell: UICollectionViewCell {
    
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        let rect = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView?.frame = rect
        if let view = imageView {
            self.contentView.addSubview(view)
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
