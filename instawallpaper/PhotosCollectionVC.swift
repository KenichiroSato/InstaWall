//
//  PhotosCollectionViewController.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/06/13.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class PhotosCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, TryReloadDelegate {

    private static let reuseIdentifier = "PictureCell"
    
    private enum Content {
        case POPULAR, FEED, SEARCH
    }
    
    static private let CELL_NUMS_IN_ROW: CGFloat = 3
    
    private var pictureArray: [InstagramMedia] = []
    private var paginationInfo: InstagramPaginationInfo? = nil
    private var currentContent:Content = .POPULAR
    private var searchText:String?
    private let instagramManager = InstagramManager()
    private var refreshControl = UIRefreshControl()
    private var isLoading = false
    private var didHitBottom = false
    
    @IBOutlet weak var tryReloadView: TryReloadView!
    
    lazy private var successBlock: SuccessLoadBlock
    = {[unowned self] (pictures, paginationInfo) in
        self.paginationInfo = paginationInfo
        self.pictureArray += pictures
        self.finishLoadingData()
    }
    
    lazy private var failureBlock:InstagramFailureBlock  = {[unowned self] error, statusCode in
        self.clearData()
        self.showErrorMessage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: Selector("refresh"),
            forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.tintColor = UIColor.whiteColor()
        self.collectionView?.addSubview(refreshControl)
        tryReloadView.reloadDelegate = self
    }
    
    private func resetPaginationInfo() {
        paginationInfo = nil
    }

    func roadTopPopular() {
        clearData()
        prepareFullScreenLoading()
        roadPopular(successBlock, failure: failureBlock)
    }
    
    private func roadPopular(success:SuccessLoadBlock, failure:InstagramFailureBlock) {
        currentContent = .POPULAR
        instagramManager.roadPopular(success, failure:failure)
    }

    func roadTopSearchItems(text: String) {
        clearData()
        prepareFullScreenLoading()
        roadSearchItems(text, success: successBlock, failure: failureBlock)
    }
    
    private func roadSearchItems(text: String, success:SuccessLoadBlock, failure:InstagramFailureBlock) {
        currentContent = .SEARCH
        searchText = text
        instagramManager.roadSearchItems(text, maxId: paginationInfo?.nextMaxId, success:success, failure:failure)
    }
    
    func roadTopSelfFeed() {
        clearData()
        prepareFullScreenLoading()
        roadSelfFeed(successBlock, failure: failureBlock)
    }
    
    private func roadSelfFeed(success:SuccessLoadBlock, failure:InstagramFailureBlock) {
        currentContent = .FEED
        instagramManager.roadSelfFeed(paginationInfo?.nextMaxId, success:success, failure: failure)
    }
    
    private func roadNext() {
        if let _ = paginationInfo?.nextMaxId {
            switch(currentContent) {
            case .POPULAR:
                return
            case .FEED:
                roadSelfFeed(successBlock, failure: failureBlock)
            case .SEARCH:
                if let text = searchText {
                    roadSearchItems(text, success:successBlock, failure: failureBlock)
                }
            }
        } else {
            didHitBottom = true
            collectionView?.reloadData()
        }
    }
    
    func refresh() {
        paginationInfo = nil
        isLoading = true
        didHitBottom = false
        let success:SuccessLoadBlock = {[unowned self] (pictures, paginationInfo) in
            self.pictureArray.removeAll(keepCapacity: false)
            self.successBlock(pictures, paginationInfo)
            self.refreshControl.endRefreshing()
        }
        let failure:InstagramFailureBlock = {[unowned self] error, statusCode in
            self.failureBlock(error, statusCode)
            self.refreshControl.endRefreshing()
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
    
    private func showErrorMessage() {
        tryReloadView.showReload()
        UIAlertController.show( NSLocalizedString("ERR_FAIL_LOAD", comment:""),
            message: nil, forVC: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == SegueIdentifier.FULL_SCREEN) {
            let nextVC = segue.destinationViewController as! PictureConfirmVC
            if let selectedIndexPath = self.collectionView?.indexPathsForSelectedItems(){
                let media: InstagramMedia = pictureArray[selectedIndexPath[0].item];
                nextVC.pictureUrl = media.standardResolutionImageURL
            }
        }
    }

    private func clearData() {
        resetPaginationInfo()
        pictureArray.removeAll(keepCapacity: false)
        self.collectionView?.reloadData()
        didHitBottom = false
    }
    
    private func prepareFullScreenLoading() {
        tryReloadView.showIndicator()
        isLoading = true
    }
    
    private func finishLoadingData() {
        tryReloadView.hide()
        isLoading = false
        self.collectionView?.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let picCount = pictureArray.count
        if (picCount == 0) { return 0 }
        if (didHitBottom) {return picCount }
        
        //This is to display activity indicator at the center cell of the bottom line
        let rest = picCount % 3
        if (rest == 0) {
            return picCount + 2
        } else if (rest == 1) {
            return picCount + 1
        } else { // rest == 2
            return picCount + 3
        }
    }

    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotosCollectionVC.reuseIdentifier, forIndexPath: indexPath)
            as! PictureCell
    
        cell.imageView.image = nil
        if (pictureArray.count >= indexPath.row + 1) {
            let media: InstagramMedia = pictureArray[indexPath.row]
            cell.imageView.setImageWithURL(media.thumbnailURL)
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
        clearData()
        prepareFullScreenLoading()
        refresh()
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
