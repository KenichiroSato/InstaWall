//
//  GridPictureVC.swift
//  instawallpaper
//
//  Created by 2ndDisplay on 2015/12/02.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class GridPictureVC: UIViewController, UICollectionViewDelegateFlowLayout,
    TryReloadDelegate, PhotosLoadDelegate {
    
    static private let CELL_NUMS_IN_ROW: CGFloat = 3
    
    private var refreshControl = UIRefreshControl()
    private var isLoading = false
    private var didHitBottom = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tryReloadView: TryReloadView!

    var dataSource: GridPictureDataSource! {
        didSet {
            collectionView.dataSource = dataSource
            dataSource.photosLoadDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: Selector("pullToRefresh"),
            forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.tintColor = UIColor.whiteColor()
        collectionView.addSubview(refreshControl)
        tryReloadView.reloadDelegate = self
    }
    
    func loadTopContent(showFullScreenLoading:Bool) {
        didHitBottom = false
        isLoading = true
        dataSource.clearData()
        if (showFullScreenLoading) {
            self.collectionView?.reloadData()
            tryReloadView.showIndicator()
        }
        dataSource.loadContent()
    }
    
    private func loadNext() {
        if dataSource.isBottom() {
            didHitBottom = true
            collectionView?.reloadData()
        } else {
            dataSource.loadContent()
        }
    }
    
    func pullToRefresh() {
        loadTopContent(false)
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
    
    private func finishLoadingData() {
        self.refreshControl.endRefreshing()
        isLoading = false
        if (dataSource.hasContents) {
            collectionView.hidden = false
            collectionView.reloadData()
        } else {
            collectionView.hidden = true
        }
    }

    
    // MARK - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let size = Screen.WIDTH() / 3
            return CGSizeMake(size, size)
    }
    
    // MARK: UICollectionViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        objc_sync_enter(self)
        if (scrollView.isCloseToBottom()) {
            if (!isLoading) {
                isLoading = true
                loadNext()
            }
        }
        objc_sync_exit(self)
    }
    
    // MARK: TryReloadDelegate
    func onTryReload() {
        loadTopContent(true)
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
