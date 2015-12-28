//
//  FullScreenPictureVC.swift
//  Photofully
//
//  Created by Kenichiro Sato on 2015/11/14.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit
import SDWebImage

class FullScreenPictureVC: UIViewController, UICollectionViewDelegate, ImageLoadDelegate, PhotosLoadDelegate {

    private static let reuseIdentifier = "FullScreenPictureCell"

    private let DEFAULT_COLOR = UIColor.blackColor()
    
    @IBOutlet var backgroundView: GradationView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var collectionView: UICollectionView =
    UICollectionView(frame: Screen.APPLICATION_FRAME(),
        collectionViewLayout: FullScreenCollectionViewLayout())
    
    private var overlayView: FullScreenOverlayView!
    //dataSource must be set when creating this VC
    var dataSource: FullScreenPictureDataSource! {
        didSet {
            collectionView.dataSource = dataSource
        }
    }
    let gestureManager = GestureInstructionManager()
    var indexDiff:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        dataSource.imageLoadDelegate = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast // Faster deceleration!
        collectionView.scrollsToTop = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerClass(FullScreenPictureCell.self, forCellWithReuseIdentifier: FullScreenPictureVC.reuseIdentifier)
        self.view.addSubview(collectionView)
        
        let fullScreenRect: CGRect = Screen.APPLICATION_FRAME()
        overlayView = FullScreenOverlayView(frame: fullScreenRect)
        self.view.addSubview(overlayView)
        self.view.bringSubviewToFront(indicator)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.photosLoadDelegate = self
        moveToIndex(dataSource.currentInternalIndex)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        dataSource.photosLoadDelegate = nil
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func showGesture() {
        if let gesture = gestureManager.gestureToBeShown() {
            gesture.show(self.view)
        }
    }

    private func moveToIndex(index: Int) {
        collectionView.contentOffset.y = CGFloat(index) * FullScreenCollectionViewLayout.DRAG_INTERVAL
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
    }
    
    private func updateViews() {
        let topColor = dataSource.pictureAtCurrentIndex()?.topColor ?? DEFAULT_COLOR
        let bottomColor = dataSource.pictureAtCurrentIndex()?.bottomColor ?? DEFAULT_COLOR
        backgroundView.updateTopColor(topColor, andBottomColor: bottomColor)
        if let height = dataSource.pictureAtCurrentIndex()?.fullScreenHeight {
            overlayView.updateGradientViews(height,
                topColor: topColor, bottomColor: bottomColor)
        }
    }

    private func hideOverlay() {
        overlayView.hideGradientViews()
    }
    
    // MARK: ImageLoadDelegate
    func onImageLoaded(index: Int) {
        if (index == dataSource.currentInternalIndex) {
            indicator.hidden = true
            updateViews()
            showGesture()
        }
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        hideOverlay()
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        self.view.disableUserAction() // user action will be enabled in scrollViewDidEndDecelerating
        updateViews()
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        /**
        * Here we target a specific cell index to move towards
        */
        let currentY = scrollView.contentOffset.y
        let yDiff: CGFloat = abs(targetContentOffset.memory.y - currentY)
        
        var nextIndex:Int
        if (velocity.y == 0) {
            // A 0 velocity means the user dragged and stopped (no flick)
            nextIndex = Int(roundf(Float(targetContentOffset.memory.y / FullScreenCollectionViewLayout.DRAG_INTERVAL)))
        } else if (velocity.y > 0) {
            // User scrolled downwards
            nextIndex = Int(ceilf(Float((targetContentOffset.memory.y -
                yDiff)/FullScreenCollectionViewLayout.DRAG_INTERVAL)))
        } else {
            // User scrolled upwards
            nextIndex = Int(floorf(Float((targetContentOffset.memory.y + yDiff) / FullScreenCollectionViewLayout.DRAG_INTERVAL)))
        }
    
        // Return our adjusted target point
        targetContentOffset.memory = CGPointMake(0, max(CGFloat(nextIndex) * FullScreenCollectionViewLayout.DRAG_INTERVAL,
        collectionView.contentInset.top))
        indexDiff = nextIndex - dataSource.currentInternalIndex
        dataSource.currentInternalIndex = nextIndex
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        dataSource.shiftCurrentIndex(indexDiff)
        collectionView.reloadData()
        moveToIndex(dataSource.currentInternalIndex)
        self.view.enableUserAction()
        gestureManager.doneDownToUp()
    }
    
    @IBAction func onSwipedRight(sender: AnyObject) {
        gestureManager.doneLeftToRight()
        dismiss()
    }
    
    @IBAction func onSwipedLeft(sender: AnyObject) {
        gestureManager.doneRightToLeft()
        openInstagramApp()
    }
    
    private func openInstagramApp() {
        var success = false
        if let id = dataSource?.pictureAtCurrentIndex()?.id {
            success = InstagramManager.openInstagramApp(id)
        }
        if (!success) {
            UIAlertController.show(Text.ERR_FAIL_OPEN_INSTAGRAM,
                message: nil, forVC: self, handler: nil)
        }
    }
    
    // MARK: PhotosLoadDelegate
    func onLoadFail() {
        UIAlertController.show( Text.ERR_FAIL_LOAD,
            message: nil, forVC: self, handler:{(_) in self.dismiss()}
        )
    }
    

}
