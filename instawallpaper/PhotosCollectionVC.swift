//
//  PhotosCollectionViewController.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/06/13.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit
import InstagramKit
import SDWebImage

class PhotosCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout,
    TryReloadDelegate, PhotosLoadDelegate {

    private static let reuseIdentifier = "PictureCell"
    
    static private let CELL_NUMS_IN_ROW: CGFloat = 3
    
    private var refreshControl = UIRefreshControl()
    private var isLoading = false
    private var didHitBottom = false
    private var dataSource: PhotosCollectionDataSource = PhotosCollectionDataSource()
    
    @IBOutlet weak var tryReloadView: TryReloadView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: Selector("refresh"),
            forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.tintColor = UIColor.whiteColor()
        self.collectionView?.addSubview(refreshControl)
        tryReloadView.reloadDelegate = self
        dataSource.photosLoadDelegate = self
    }
    
    func roadTopPopular() {
        dataSource.clearData()
        prepareFullScreenLoading()
        dataSource.roadTopPopular()
    }
    
    func roadTopSearchItems(text: String) {
        dataSource.clearData()
        prepareFullScreenLoading()
        dataSource.roadTopSearchItems(text)
    }
    
    func roadTopSelfFeed() {
        dataSource.clearData()
        prepareFullScreenLoading()
        dataSource.roadTopSelfFeed()
    }
    
    private func roadNext() {
        if dataSource.isBottom() {
            didHitBottom = true
            collectionView?.reloadData()
        } else {
            dataSource.roadNext()
        }
    }
    
    func refresh() {
        isLoading = true
        didHitBottom = false
        dataSource.refresh()
    }
    
    private func showErrorMessage() {
        tryReloadView.showReload()
        UIAlertController.show( Text.ERR_FAIL_LOAD,
            message: nil, forVC: self, handler:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == SegueIdentifier.FULL_SCREEN) {
            /*
            if let selectedIndexPath = self.collectionView?.indexPathsForSelectedItems(),
                let cell = self.collectionView?.cellForItemAtIndexPath(selectedIndexPath[0]) as? PictureCell {
                    let nextVC = segue.destinationViewController as! PictureConfirmVC
                    let media: InstagramMedia = pictureArray[selectedIndexPath[0].item];
                    nextVC.instagramMedia = media
                    nextVC.placeHosderImage = cell.imageView.image
            
            }
            */
            if let selectedIndexPath = self.collectionView?.indexPathsForSelectedItems() {
                let nextVC = segue.destinationViewController as! FullScreenPictureVC
                let source = FullScreenPictureDataSource(mediaArray: self.dataSource.pictureArray)
                nextVC.dataSource = source
                let indexPath = selectedIndexPath[0]
                nextVC.currentIndex = indexPath.item
            }
        }
    }

    private func prepareFullScreenLoading() {
        self.collectionView?.reloadData()
        didHitBottom = false
        tryReloadView.showIndicator()
        isLoading = true
    }
    
    private func finishLoadingData() {
        self.refreshControl.endRefreshing()
        isLoading = false
        self.collectionView?.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let picCount = dataSource.pictureArray.count
        return numberOfItems(picCount, didHitBottom: didHitBottom)
    }
    
    private func numberOfItems(count: Int, didHitBottom: Bool) -> Int{
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

    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotosCollectionVC.reuseIdentifier, forIndexPath: indexPath)
            as! PictureCell
    
        cell.imageView.image = nil
        if (dataSource.pictureArray.count >= indexPath.row + 1) {
            let media: InstagramMedia = dataSource.pictureArray[indexPath.row]
            cell.imageView.sd_setImageWithURL(media.thumbnailURL,
                placeholderImage:nil, options: SDWebImageOptions.RetryFailed)
            cell.indicator.hidden = true
        } else if (indexPath.item == collectionView.numberOfItemsInSection(0) - 1){
            //cell is the second from the end, which means indicator should be displayed.
            cell.indicator.hidden = false
        }
        return cell
    }
    
    // MARK - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if let width = self.collectionView?.bounds.size.width {
            let size = width / PhotosCollectionVC.CELL_NUMS_IN_ROW
            return CGSizeMake(size, size)
        } else {
            return CGSizeMake(320, 320)
        }
    }

    // MARK: UICollectionViewDelegate
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        objc_sync_enter(self)
        if (scrollView.isCloseToBottom()) {
            if (!isLoading) {
                isLoading = true
                roadNext()
            }
        }
        objc_sync_exit(self)
    }
    
    // MARK: TryReloadDelegate
    func onTryReload() {
        dataSource.clearData()
        prepareFullScreenLoading()
        refresh()
    }
    
    // MARK: PhotosLoadDelegate
    func onLoadSuccess() {
        tryReloadView.hide()
        finishLoadingData()
    }
    
    func onLoadFail() {
        finishLoadingData()
        showErrorMessage()
    }
    
}

// Only for UnitTest
extension PhotosCollectionVC {
    func numberOfItemsTest(count: Int, didHitBottom: Bool) -> Int{
        return self.numberOfItems(count, didHitBottom: didHitBottom)
    }
}


