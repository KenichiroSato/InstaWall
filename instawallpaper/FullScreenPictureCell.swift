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
        imageView?.translatesAutoresizingMaskIntoConstraints = false;
        imageView?.contentMode = UIViewContentMode.ScaleAspectFill//UIViewContentModeScaleAspectFill;
        imageView?.clipsToBounds = true;
        if let view = imageView {
            self.contentView.addSubview(view)
        }
        
        // Auto Layout
        var viewBindingsDict: [String: AnyObject] = [String: AnyObject]()
        viewBindingsDict["imageView"] = imageView
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("|[imageView]|", options:NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewBindingsDict)
        self.contentView.addConstraints(constraints)
        let constraints2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options:NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewBindingsDict)
        self.contentView.addConstraints(constraints2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
