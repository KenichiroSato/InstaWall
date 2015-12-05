//
//  FullScreenPictureDataSource.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/11/19.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit
import InstagramKit
import SDWebImage

protocol ImageLoadDelegate {
    func onImageLoaded(index: Int)
}

class FullScreenPictureDataSource :NSObject, UICollectionViewDataSource{
    
    private let REUSE_IDENTIFIER = "FullScreenPictureCell"
    
    private let DEFAULT_COLOR = UIColor.blackColor()
    
    private var pictureArray: [(media:InstagramMedia, topColor:UIColor, bottomColor:UIColor)] = []
    
    var imageLoadDelegate: ImageLoadDelegate?
    
    init(mediaArray:[InstagramMedia]) {
        for media in mediaArray {
            pictureArray += [(media, DEFAULT_COLOR, DEFAULT_COLOR)]
        }
    }
    
    func heightOfCellAtIndex(index:Int) -> CGFloat? {
        guard (0 <= index && index < pictureArray.count) else {
            return nil
        }
        let size = pictureArray[index].media.standardResolutionImageFrameSize
        return Screen.WIDTH() * size.height / size.width
    }
    
    func mediaIdOfCellAtIndex(index:Int) -> String? {
        guard (0 <= index && index < pictureArray.count) else {
            return nil
        }
        return pictureArray[index].media.Id
    }
    
    func topColorOfCellAtIndex(index:Int) -> UIColor {
        guard (0 <= index && index < pictureArray.count) else {
            return DEFAULT_COLOR
        }
        return pictureArray[index].topColor
    }

    func bottomColorOfCellAtIndex(index:Int) -> UIColor {
        guard (0 <= index && index < pictureArray.count) else {
            return DEFAULT_COLOR
        }
        return pictureArray[index].bottomColor
    }

    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureArray.count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(REUSE_IDENTIFIER, forIndexPath: indexPath)
                as! FullScreenPictureCell
            
            if let imgView = cell.imageView {
                imgView.image = nil
                let media: InstagramMedia = pictureArray[indexPath.row].media
                imgView.sd_setImageWithURL(media.standardResolutionImageURL,
                    placeholderImage:nil, options: SDWebImageOptions.RetryFailed,
                    completed: {(image, error, _, _) in
                        if (error == nil) {
                            self.pictureArray[indexPath.row].topColor =
                                ImageUtil.mostFrequentColor(image, position: ImageUtil.Position.TOP)
                            self.pictureArray[indexPath.row].bottomColor =
                                ImageUtil.mostFrequentColor(image, position: ImageUtil.Position.BOTTOM)
                            if let delegate = self.imageLoadDelegate {
                                delegate.onImageLoaded(indexPath.row)
                            }
                        }
                })
            }
            return cell
    }
}
