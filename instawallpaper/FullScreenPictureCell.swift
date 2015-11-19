//
//  FullScreenPictureCell.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/11/15.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class FullScreenPictureCell: UICollectionViewCell {
    
    private let DEFAULT_OPACITY: CGFloat = 1.0
    
    var imageView: UIImageView?
    var shadowView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        imageView?.translatesAutoresizingMaskIntoConstraints = false;
        imageView?.contentMode = UIViewContentMode.ScaleAspectFill//UIViewContentModeScaleAspectFill;
        imageView?.clipsToBounds = true;
        if let view = imageView {
            self.contentView.addSubview(view)
        }
        
        shadowView = UIView()
        shadowView?.translatesAutoresizingMaskIntoConstraints = false;
        //shadowView?.backgroundColor = UIColor.clearColor()
        if let shadow = shadowView {
            self.contentView.addSubview(shadow)
        }
        
        // Auto Layout
        var viewBindingsDict: [String: AnyObject] = [String: AnyObject]()
        viewBindingsDict["imageView"] = imageView
        viewBindingsDict["shadowView"] = shadowView
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("|[imageView]|", options:NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewBindingsDict)
        self.contentView.addConstraints(constraints)
        let constraints2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options:NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewBindingsDict)
        self.contentView.addConstraints(constraints2)
        let constraints3 = NSLayoutConstraint.constraintsWithVisualFormat("|[shadowView]|", options:NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewBindingsDict)
        self.contentView.addConstraints(constraints3)
        let constraints4 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[shadowView]|", options:NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewBindingsDict)
        self.contentView.addConstraints(constraints4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)

        // Calculate how much the cell has 'grown' towards its active height
        // Featured cells will be 1.0
        // Default cells are 0.0
        // Incoming cells will be somewhere between
        /*
        let hardHeightDiff: CGFloat = FullScreenCollectionViewLayout.ACTIVE_HEIGHT - FullScreenCollectionViewLayout.DEFAULT_HEIGHT
        let amountGrown: CGFloat = FullScreenCollectionViewLayout.ACTIVE_HEIGHT - layoutAttributes.frame.size.height
        let percentOfGrowth: CGFloat = min(1 - (amountGrown / hardHeightDiff), 1.0)
    
        if (percentOfGrowth > 0.0) {
            shadowView?.layer.opacity = Float(DEFAULT_OPACITY - percentOfGrowth)
        } else {
            shadowView?.layer.opacity = Float(DEFAULT_OPACITY)
        }
*/
    }

}
