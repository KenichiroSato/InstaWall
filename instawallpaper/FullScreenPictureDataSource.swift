//
//  FullScreenPictureDataSource.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/11/19.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit
import SDWebImage

protocol ImageLoadDelegate {
    func onImageLoaded(index: Int)
}

class FullScreenPictureDataSource :NSObject, UICollectionViewDataSource {
    
    private let REUSE_IDENTIFIER = "FullScreenPictureCell"
    
    var ARRAY_RANGE: Int {
        return 5
    }

    private var TOTAL_PIC_NUM: Int {
        return ARRAY_RANGE * 2 + 1
    }

    private var pictureArray: [Picture] = []
    
    var imageLoadDelegate: ImageLoadDelegate?
    
    var contentLoader: ContentLoader
    
    var currentIndex: Int = 0
    
/*
    init(mediaArray:[Picture]) {
        pictureArray += mediaArray
    }
*/
    init (selectedIndex:Int, loader:ContentLoader) {
        contentLoader = loader
        super.init()
        let pictures = contentLoader.pictureArray
        let range = initialArrayRange(selectedIndex, arrayCount: pictures.count)
        pictureArray = Array(pictures[range.bottom...range.top])
        currentIndex = initialIndex(selectedIndex)
    }
    
    private func initialIndex(selectedIndex:Int) -> Int {
        if (selectedIndex < ARRAY_RANGE) {
            return selectedIndex
        }
        return ARRAY_RANGE
    }
    
    private func initialArrayRange(selectedIndex:Int, arrayCount:Int) -> (bottom:Int, top:Int) {
        let maxIndex = arrayCount - 1
        if (selectedIndex < 0 || selectedIndex >= arrayCount) {
            return (0, TOTAL_PIC_NUM - 1)
        }
        if (arrayCount <= TOTAL_PIC_NUM ) {
            return (0, maxIndex)
        }
        if (selectedIndex - ARRAY_RANGE < 0) {
            return (0, selectedIndex + ARRAY_RANGE)
        }
        if (selectedIndex + ARRAY_RANGE > maxIndex) {
            return (selectedIndex - ARRAY_RANGE, maxIndex)
        }
        return (selectedIndex - ARRAY_RANGE, selectedIndex + ARRAY_RANGE)
    }
    
    func pictureCount() -> Int {
        return pictureArray.count
    }
    
    func pictureAtIndex(index:Int) -> Picture? {
        guard (0 <= index && index < pictureArray.count) else {
            return nil
        }
        return pictureArray[index]
    }
    
    func pictureAtCurrentIndex() -> Picture? {
        return pictureAtIndex(currentIndex)
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
                let picture = pictureArray[indexPath.row]
                imgView.sd_setImageWithURL(picture.imageURL,
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
