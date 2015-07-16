//
//  PhotosCollectionViewController.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/06/13.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

let reuseIdentifier = "PictureCell"

class PhotosCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    typealias SuccessLoadBlock = (([InstagramMedia], InstagramPaginationInfo?) -> Void)
    
    private enum Content {
        case POPULAR, FEED, SEARCH
    }
    
    static private let CELL_NUMS_IN_ROW: CGFloat = 3
    
    private var pictureArray: [InstagramMedia] = []
    private var paginationInfo: InstagramPaginationInfo? = nil
    private var currentContent:Content = .POPULAR
    private var searchText:String?
    private let instagramManager = InstagramManager()
    
    lazy private var successBlock: SuccessLoadBlock
    = {[unowned self] (pictures, paginationInfo) in
        self.paginationInfo = paginationInfo
        self.pictureArray += pictures
        self.finishLoadingData()
    }
    
    lazy private var failureBlock:InstagramFailureBlock  = {[unowned self] error, statusCode in
        self.showErrorMessage()
    }
    
    private var refreshControl = UIRefreshControl()

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: Selector("refresh"),
            forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView?.addSubview(refreshControl)
    }
    
    private func resetPaginationInfo() {
        paginationInfo = nil
    }

    func roadPopularPictures() {
        roadPopularPictures(successBlock, failure: failureBlock)
    }
    
    private func roadPopularPictures(success:SuccessLoadBlock, failure:InstagramFailureBlock) {
        prepareLoadingData()
        currentContent = .POPULAR
        instagramManager.roadPopularPictures(success, failure:failure)
    }

    func roadFromText(text: String) {
        roadFromText(text, success: successBlock, failure: failureBlock)
    }
    
    private func roadFromText(text: String, success:SuccessLoadBlock, failure:InstagramFailureBlock) {
        prepareLoadingData()
        currentContent = .SEARCH
        searchText = text
        instagramManager.roadTopSearchItems(text, success:success, failure:failure)
    }
    
    func roadTopSelfFeed() {
        roadTopSelfFeed(successBlock, failure: failureBlock)
    }
    
    private func roadTopSelfFeed(success:SuccessLoadBlock, failure:InstagramFailureBlock) {
        prepareLoadingData()
        currentContent = .FEED
        instagramManager.roadTopSeflFeed(success, failure:failure)
    }
    
    private func roadNext() {
        if let info = paginationInfo?.nextMaxId {
            instagramManager.roadNext(info, success:successBlock, failure:failureBlock)
        } else {
            println("already bottom")
        }
    }
    
    func refresh() {
        let success:SuccessLoadBlock = {[unowned self] (pictures, paginationInfo) in
            self.refreshControl.endRefreshing()
            self.pictureArray.removeAll(keepCapacity: false)
            self.successBlock(pictures, paginationInfo)
        }
        switch(currentContent) {
        case .POPULAR:
            roadPopularPictures(success, failure: failureBlock)
        case .FEED:
            roadTopSelfFeed(success, failure: failureBlock)
        case .SEARCH:
            if let text = searchText {
                roadFromText(text, success:success, failure: failureBlock)
            }
        }
        /*
        InstagramManager.sharedInstance.refresh({
            pictures in
            self.refreshControl.endRefreshing()
            self.pictureArray.removeAll(keepCapacity: false)
            self.pictureArray += pictures
            self.finishLoadingData()
            }, failure: { error, statusCode in
                self.showErrorMessage()
        })
*/
    }
    
    private func showErrorMessage() {
        indicatorView.hidden = true
        UIAlertController.show(Text.ERR_FAIL_LOAD, message: nil, forVC: self)
    }
    
    private func isLoading() -> Bool {
        return !indicatorView.hidden
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segue.fullscreen") {
            let nextVC = segue.destinationViewController as! PictureConfirmVC
            if let selectedIndexPath = self.collectionView?.indexPathsForSelectedItems()[0] as? NSIndexPath {
                let media: InstagramMedia = pictureArray[selectedIndexPath.item];
                nextVC.pictureUrl = media.standardResolutionImageURL
            }
        }
    }

    private func prepareLoadingData() {
        resetPaginationInfo()
        pictureArray.removeAll(keepCapacity: false)
        self.collectionView?.reloadData()
        indicatorView.hidden = false
    }
    
    private func finishLoadingData() {
        indicatorView.hidden = true
        self.collectionView?.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureArray.count
    }

    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
            as! PictureCell
    
        cell.imageView.image = nil
        if (pictureArray.count >= indexPath.row + 1) {
            let media: InstagramMedia = pictureArray[indexPath.row]
            cell.imageView.setImageWithURL(media.thumbnailURL)
        }
        return cell
    }
    
    // MARK - UITextFieldDelegate methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = textField.text {
            roadFromText(text)
        }
        textField.resignFirstResponder()
        return true
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
            if (!isLoading()) {
                indicatorView.hidden = false
                roadNext()
            }
            //reach bottom
        }        
        objc_sync_exit(self)
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
