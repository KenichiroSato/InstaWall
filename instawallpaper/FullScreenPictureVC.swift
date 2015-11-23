//
//  FullScreenPictureVC.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/11/14.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit
import InstagramKit
import SDWebImage

class FullScreenPictureVC: UIViewController, UICollectionViewDelegate, ImageLoadDelegate {

    private static let DRAG_VELOCITY_DAMPENER: CGFloat = 0.85
    
    private static let reuseIdentifier = "FullScreenPictureCell"

    @IBOutlet var backgroundView: GradationView!
    private var collectionView: UICollectionView!
    private var overlayView: FullScreenOverlayView!
    var currentIndex: Int = 0
    var dataSource: FullScreenPictureDataSource?
    let layout: FullScreenCollectionViewLayout = FullScreenCollectionViewLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullScreenRect: CGRect = UIScreen.mainScreen().applicationFrame  //[[UIScreen mainScreen] applicationFrame];
        collectionView = UICollectionView(frame: fullScreenRect, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.dataSource = dataSource
        dataSource?.imageLoadDelegate = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast // Faster deceleration!
        collectionView.scrollsToTop = true
        collectionView.registerClass(FullScreenPictureCell.self, forCellWithReuseIdentifier: FullScreenPictureVC.reuseIdentifier)
        self.view.addSubview(collectionView)
        
        overlayView = FullScreenOverlayView(frame: fullScreenRect)
        self.view.addSubview(overlayView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        moveToIndex(currentIndex)
    }

    private func moveToIndex(index: Int) {
        collectionView.contentOffset.y = CGFloat(index) * FullScreenCollectionViewLayout.DRAG_INTERVAL
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
    }
    
    private func updateViews() {
        guard let source = dataSource else {
            return
        }
        let topColor = source.topColorOfCellAtIndex(currentIndex)
        let bottomColor = source.bottomColorOfCellAtIndex(currentIndex)
        backgroundView.updateTopColor(topColor, andBottomColor: bottomColor)
        if let height = source.heightOfCellAtIndex(currentIndex) {
            overlayView.updateGradientViews(height,
                topColor: topColor, bottomColor: bottomColor)
        }
    }

    private func hideOverlay() {
        overlayView.hideGradientViews()
    }
    
    // MARK: ImageLoadDelegate
    func onImageLoaded(index: Int) {
        if (index == currentIndex) {
            updateViews()
        }
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        hideOverlay()
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        updateViews()
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        /**
        * Here we target a specific cell index to move towards
        */
        let currentY = scrollView.contentOffset.y
        let yDiff: CGFloat = abs(targetContentOffset.memory.y - currentY)
        
        if (velocity.y == 0)
        {
            // A 0 velocity means the user dragged and stopped (no flick)
            // In this case, tell the scroll view to animate to the closest index
            currentIndex = Int(roundf(Float(targetContentOffset.memory.y / FullScreenCollectionViewLayout.DRAG_INTERVAL)))
            targetContentOffset.memory = CGPointMake(0, CGFloat(currentIndex) * FullScreenCollectionViewLayout.DRAG_INTERVAL)
        }
        else if (velocity.y > 0)
        {
            // User scrolled downwards
            // Evaluate to the nearest index
            // Err towards closer a index by forcing a slightly closer target offset
            currentIndex = Int(ceilf(Float((targetContentOffset.memory.y -
                (yDiff * FullScreenPictureVC.DRAG_VELOCITY_DAMPENER))/FullScreenCollectionViewLayout.DRAG_INTERVAL)))
        }
        else
        {
            // User scrolled upwards
            // Evaluate to the nearest index
            // Err towards closer a index by forcing a slightly closer target offset
            currentIndex = Int(floorf(Float((targetContentOffset.memory.y + (yDiff * FullScreenPictureVC.DRAG_VELOCITY_DAMPENER)) / FullScreenCollectionViewLayout.DRAG_INTERVAL)))
        }
    
        // Return our adjusted target point
        targetContentOffset.memory = CGPointMake(0, max(CGFloat(currentIndex) * FullScreenCollectionViewLayout.DRAG_INTERVAL,
        collectionView.contentInset.top))
    }
    
    @IBAction func onSwipedRight(sender: AnyObject) {
        dismiss()
    }

    private func dismiss() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
