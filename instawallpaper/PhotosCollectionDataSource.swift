//
//  PhotosCollectionDataSource.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/11/28.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit
import InstagramKit
import SDWebImage

protocol PhotosLoadDelegate {
    func onLoadSuccess()
    func onLoadFail()
}

class PhotosCollectionDataSource: NSObject {

    private let REUSE_IDENTIFIER = "PictureCell"
    
    var pictureArray: [InstagramMedia] {
        return contentLoader.pictureArray
    }
    
    var photosLoadDelegate: PhotosLoadDelegate? {
        set(delegate) {
            contentLoader.photosLoadDelegate = delegate
        }
        get {
            return contentLoader.photosLoadDelegate
        }
    }
    
    var contentLoader: ContentLoader
    
    init(contentLoader: ContentLoader) {
        self.contentLoader = contentLoader
        super.init()
    }

    func loadContent() {
        contentLoader.loadContent()
    }
    
    func isBottom() -> Bool {
        if let _ = contentLoader.paginationInfo?.nextMaxId {
            return false
        } else {
            return true
        }
    }
    
    func clearData() {
        contentLoader.clearData()
    }

    func numberOfItems(didHitBottom:Bool) -> Int {
        return numberOfItems(pictureArray.count, didHitBottom: didHitBottom)
    }

    func numberOfItems(count:Int, didHitBottom:Bool) -> Int {
        if (count == 0) { return 0 }
        if (didHitBottom) {return count }
        
        //This is to display activity indicator at the center cell of the bottom line
        let rest = count % 3
        if (rest == 0) {
            return count + 2
        } else if (rest == 1) {
            return count + 1
        } else { // rest == 2
            return count + 3
        }
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(REUSE_IDENTIFIER, forIndexPath: indexPath)
                as! PictureCell
            
            cell.imageView.image = nil
            if (pictureArray.count >= indexPath.row + 1) {
                let media: InstagramMedia = pictureArray[indexPath.row]
                cell.imageView.sd_setImageWithURL(media.thumbnailURL,
                    placeholderImage:nil, options: SDWebImageOptions.RetryFailed)
                cell.indicator.hidden = true
            } else if (indexPath.item == collectionView.numberOfItemsInSection(0) - 1){
                //cell is the second from the end, which means indicator should be displayed.
                cell.indicator.hidden = false
            }
            return cell
    }


}
