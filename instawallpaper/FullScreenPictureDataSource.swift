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
    
    private let LOADER_TRIGGER_INDEX = 10
    
    // This indicates how many contents should be loaded
    // before and after currently displayed content
    var ARRAY_RANGE: Int {
        return 2
    }

    // 1 means currently displayed content.
    // * 2 means before and after
    private var TOTAL_PIC_NUM: Int {
        return ARRAY_RANGE * 2 + 1
    }

    private var pictureArray: [Picture] = []
    
    var imageLoadDelegate: ImageLoadDelegate?
    
    var contentLoader: ContentLoader
    
    // Index of this dataSource's list
    var currentInternalIndex: Int = 0
    
    // Index of whole content list which contentLoader has
    var contentLoaderIndex: Int = 0
    
    init (selectedIndex:Int, loader:ContentLoader) {
        contentLoader = loader
        super.init()
        updateIndex(selectedIndex)
    }
    
    private func updateIndex(newContenteLoaderIndex: Int) {
        contentLoaderIndex = newContenteLoaderIndex
        updatePictureArray()
        updateCurrentInternalIndex()
    }
    
    private func updateCurrentInternalIndex() {
        let newInternalIndex: Int
        if (contentLoaderIndex < ARRAY_RANGE) {
            newInternalIndex = contentLoaderIndex
        } else {
            newInternalIndex = ARRAY_RANGE
        }
        currentInternalIndex = newInternalIndex
    }
    
    private func updatePictureArray() {
        let arrayCount = contentLoader.pictureArray.count
        guard 0 <= contentLoaderIndex && contentLoaderIndex < arrayCount else {
            return
        }
        
        let range:(bottom:Int, top:Int)
        let maxIndex = arrayCount - 1
        if (arrayCount <= TOTAL_PIC_NUM ) {
            range = (0, maxIndex)
        } else if (contentLoaderIndex - ARRAY_RANGE < 0) {
            range =  (0, contentLoaderIndex + ARRAY_RANGE)
        } else if (contentLoaderIndex + ARRAY_RANGE > maxIndex) {
            range = (contentLoaderIndex - ARRAY_RANGE, maxIndex)
        } else {
            range = (contentLoaderIndex - ARRAY_RANGE, contentLoaderIndex + ARRAY_RANGE)
        }
        let pictures = contentLoader.pictureArray
        pictureArray = Array(pictures[range.bottom...range.top])
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
        return pictureAtIndex(currentInternalIndex)
    }
    
    func shiftCurrentIndex(diff: Int) {
        updateIndex(contentLoaderIndex + diff)
        if (shouldTriggerLoad()) {
            contentLoader.loadContent()
            print("load Next!!!!!")
        }
    }

    private func shouldTriggerLoad() -> Bool {
        if (contentLoader.pictureArray.count - contentLoaderIndex < LOADER_TRIGGER_INDEX) {
            return true
        } else {
            return false
        }
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
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(REUSE_IDENTIFIER, forIndexPath: indexPath) as! FullScreenPictureCell
            
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
