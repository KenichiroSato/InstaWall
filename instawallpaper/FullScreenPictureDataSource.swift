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

class FullScreenPictureDataSource :NSObject, UICollectionViewDataSource{
    
    private let REUSE_IDENTIFIER = "FullScreenPictureCell"
    
    private var pictureArray: [InstagramMedia] = []
    
    init(mediaArray:[InstagramMedia]) {
        pictureArray = mediaArray
    }
    
    func heightOfCellAtIndex(index:Int) -> CGFloat? {
        guard (0 <= index && index < pictureArray.count) else {
            return nil
        }
        let size = pictureArray[index].standardResolutionImageFrameSize
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        return screenWidth * size.height / size.width
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
                let media: InstagramMedia = pictureArray[indexPath.row]
                imgView.sd_setImageWithURL(media.standardResolutionImageURL,
                    placeholderImage:nil, options: SDWebImageOptions.RetryFailed)
            }
            return cell
    }
}
