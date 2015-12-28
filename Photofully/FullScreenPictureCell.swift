//
//  FullScreenPictureCell.swift
//  Photofully
//
//  Created by Kenichiro Sato on 2015/11/15.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class FullScreenPictureCell: UICollectionViewCell {
    
    var imageView: UIImageView
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.contentMode = UIViewContentMode.ScaleAspectFill//UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = true;
        super.init(frame: frame)

        self.contentView.addSubview(imageView)
        
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
