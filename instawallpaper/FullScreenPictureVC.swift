//
//  FullScreenPictureVC.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/11/14.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit
import SDWebImage

class FullScreenPictureVC: UIViewController, UICollectionViewDelegate, ImageLoadDelegate {

    private static let reuseIdentifier = "FullScreenPictureCell"

    private let DEFAULT_COLOR = UIColor.blackColor()
    
    @IBOutlet var backgroundView: GradationView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var collectionView: UICollectionView!
    private var overlayView: FullScreenOverlayView!
    //dataSource must be set when creating this VC
    var dataSource: FullScreenPictureDataSource!
    let layout: FullScreenCollectionViewLayout = FullScreenCollectionViewLayout()
    let gestureManager = GestureInstructionManager()
    var indexDiff:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullScreenRect: CGRect = Screen.APPLICATION_FRAME()
        collectionView = UICollectionView(frame: fullScreenRect, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.dataSource = dataSource
        dataSource.imageLoadDelegate = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast // Faster deceleration!
        collectionView.scrollsToTop = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerClass(FullScreenPictureCell.self, forCellWithReuseIdentifier: FullScreenPictureVC.reuseIdentifier)
        self.view.addSubview(collectionView)
        
        overlayView = FullScreenOverlayView(frame: fullScreenRect)
        self.view.addSubview(overlayView)
        self.view.bringSubviewToFront(indicator)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        moveToIndex(dataSource.currentInternalIndex)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showGesture()
    }
    
    private func showGesture() {
        if let gesture = gestureManager.gestureToBeShown() {
            gesture.show(self)
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
        }
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        hideOverlay()
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        disableUserAction() // user action will be enabled in scrollViewDidEndDecelerating
        updateViews()
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        /**
        * Here we target a specific cell index to move towards
        */
        let currentY = scrollView.contentOffset.y
        let yDiff: CGFloat = abs(targetContentOffset.memory.y - currentY)
        
        var nextIndex:Int
        if (velocity.y == 0)
        {
            // A 0 velocity means the user dragged and stopped (no flick)
            // In this case, tell the scroll view to animate to the closest index
            nextIndex = Int(roundf(Float(targetContentOffset.memory.y / FullScreenCollectionViewLayout.DRAG_INTERVAL)))
        }
        else if (velocity.y > 0)
        {
            // User scrolled downwards
            // Evaluate to the nearest index
            // Err towards closer a index by forcing a slightly closer target offset
            nextIndex = Int(ceilf(Float((targetContentOffset.memory.y -
                yDiff)/FullScreenCollectionViewLayout.DRAG_INTERVAL)))
        }
        else
        {
            // User scrolled upwards
            // Evaluate to the nearest index
            // Err towards closer a index by forcing a slightly closer target offset
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
        enableUserAction()
        gestureManager.doneDownToUp()
        showGesture()
    }
    
    private func disableUserAction() {
        self.view.userInteractionEnabled = false
    }
    
    private func enableUserAction() {
        self.view.userInteractionEnabled = true
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
    
    private func dismiss() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
