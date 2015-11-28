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
    
    private enum Content {
        case POPULAR, FEED, SEARCH
    }
    
    var pictureArray: [InstagramMedia] = []
    private var paginationInfo: InstagramPaginationInfo? = nil
    private var currentContent:Content = .POPULAR
    private var searchText:String?
    private let instagramManager = InstagramManager()
    var photosLoadDelegate: PhotosLoadDelegate?

    lazy private var successBlock: SuccessLoadBlock
    = {[unowned self] (pictures, paginationInfo) in
        self.paginationInfo = paginationInfo
        self.pictureArray += pictures
        self.photosLoadDelegate?.onLoadSuccess()
    }
    
    lazy private var failureBlock:InstagramFailureBlock  = {[unowned self] error, statusCode in
        self.clearData()
        self.photosLoadDelegate?.onLoadFail()
    }
 
    private func resetPaginationInfo() {
        paginationInfo = nil
    }
    
    func roadTopPopular() {
        roadPopular(successBlock, failure: failureBlock)
    }
    
    private func roadPopular(success:SuccessLoadBlock, failure:InstagramFailureBlock) {
        currentContent = .POPULAR
        instagramManager.roadPopular(success, failure:failure)
    }
    
    func roadTopSearchItems(text: String) {
        roadSearchItems(text, success: successBlock, failure: failureBlock)
    }
    
    private func roadSearchItems(text: String, success:SuccessLoadBlock, failure:InstagramFailureBlock) {
        currentContent = .SEARCH
        searchText = text
        instagramManager.roadSearchItems(text, maxId: paginationInfo?.nextMaxId, success:success, failure:failure)
    }
    
    func roadTopSelfFeed() {
        roadSelfFeed(successBlock, failure: failureBlock)
    }
    
    private func roadSelfFeed(success:SuccessLoadBlock, failure:InstagramFailureBlock) {
        currentContent = .FEED
        instagramManager.roadSelfFeed(paginationInfo?.nextMaxId, success:success, failure: failure)
    }
    
    func isBottom() -> Bool {
        if let _ = paginationInfo?.nextMaxId {
            return false
        } else {
            return true
        }
    }
    
    func roadNext() {
        guard let _ = paginationInfo?.nextMaxId else {
            return
        }
        switch(currentContent) {
        case .POPULAR:
            //nop
            break
        case .FEED:
            roadSelfFeed(successBlock, failure: failureBlock)
        case .SEARCH:
            if let text = searchText {
                roadSearchItems(text, success:successBlock, failure: failureBlock)
            }
        }
    }
    
    func refresh() {
        paginationInfo = nil
        let success:SuccessLoadBlock = {[unowned self] (pictures, paginationInfo) in
            self.pictureArray.removeAll(keepCapacity: false)
            self.successBlock(pictures, paginationInfo)
        }
        let failure:InstagramFailureBlock = {[unowned self] error, statusCode in
            self.failureBlock(error, statusCode)
        }
        
        switch(currentContent) {
        case .POPULAR:
            roadPopular(success, failure: failure)
        case .FEED:
            roadSelfFeed(success, failure: failure)
        case .SEARCH:
            if let text = searchText {
                roadSearchItems(text, success:success, failure: failure)
            }
        }
    }
    
    func clearData() {
        resetPaginationInfo()
        pictureArray.removeAll(keepCapacity: false)
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
