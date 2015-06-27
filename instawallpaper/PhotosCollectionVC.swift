//
//  PhotosCollectionViewController.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/06/13.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

let reuseIdentifier = "PictureCell"

class PhotosCollectionVC: UICollectionViewController, LogInDelegate, UICollectionViewDelegateFlowLayout {

    static private let CELL_NUMS_IN_ROW: CGFloat = 3
    
    private var pictureArray: [InstagramMedia] = []
    private var paginationInfo: InstagramPaginationInfo? = nil
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roadPopularPictures()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false        
    }

    private func roadPopularPictures() {
        prepareLoadingData()
        InstagramManager.sharedInstance.roadPopularPictures({
            pictures in
            self.pictureArray += pictures
            self.finishLoadingData()
            }, failure: {error, statusCode in
                self.showErrorMessage()
        })
    }

    private func roadFromText(text: String) {
        prepareLoadingData()
        InstagramManager.sharedInstance.roadTopSearchItems(text, success: {
            pictures in
            self.pictureArray += pictures
            self.finishLoadingData()
            }, failure: {error, statusCode in
                self.showErrorMessage()
        })
    }
    
    private func roadTopSelfFeed() {
        prepareLoadingData()
        InstagramManager.sharedInstance.roadTopSeflFeed({
            pictures in
                self.pictureArray += pictures
                self.finishLoadingData()
            }, failure: {error, statusCode in
                self.showErrorMessage()
        })
    }
    
    private func roadNext() {
        InstagramManager.sharedInstance.roadNext({
            pictures in
                self.pictureArray += pictures
                self.finishLoadingData()
            }, failure: { error, statusCode in
                self.showErrorMessage()
        })
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

    // MARK: LogInDelegate
    func onLoggedIn(token: String) {
        InstagramEngine.sharedEngine().accessToken = token
        roadTopSelfFeed()
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
        if (segue.identifier == "segue.login") {
            let nextVC = segue.destinationViewController as! LoginVC
            nextVC.logInDelegate = self
        }
    }

    private func prepareLoadingData() {
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
    
        if (pictureArray.count >= indexPath.row + 1) {
            let media: InstagramMedia = pictureArray[indexPath.row]
            cell.imageView.setImageWithURL(media.thumbnailURL)
        } else {
            cell.imageView.setImageWithURL(nil)
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
        
        if (scrollView.isHitBottom()) {
            objc_sync_enter(indicatorView)
            if (!isLoading()) {
                indicatorView.hidden = false
                roadNext()
            }
            objc_sync_exit(indicatorView)
            //reach bottom
        }
        
        if (scrollView.isHitTop()){
            print("did hit top")
            //reach top
        }
        
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
