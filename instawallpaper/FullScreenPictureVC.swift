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

class FullScreenPictureVC: UIViewController, UICollectionViewDelegate {

    private static let DRAG_VELOCITY_DAMPENER: CGFloat = 0.85
    
    private static let reuseIdentifier = "FullScreenPictureCell"

    //private let layout: KTUVDemoLayout
    var pictureArray: [InstagramMedia] = []
    var initialIndex: Int?
    private var dataSource: FullScreenPictureDataSource?
    private var collectionView: UICollectionView!
    let layout: FullScreenCollectionViewLayout = FullScreenCollectionViewLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullScreenRect: CGRect = UIScreen.mainScreen().applicationFrame  //[[UIScreen mainScreen] applicationFrame];
        collectionView = UICollectionView(frame: fullScreenRect, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.blackColor()
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        dataSource = FullScreenPictureDataSource(mediaArray: pictureArray)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast // Faster deceleration!
        collectionView.scrollsToTop = true
        collectionView.registerClass(FullScreenPictureCell.self, forCellWithReuseIdentifier: FullScreenPictureVC.reuseIdentifier)
        self.view.addSubview(collectionView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let index = initialIndex {
            moveToIndex(index)
        }
    }

    private func moveToIndex(index: Int) {
        collectionView.contentOffset.y = CGFloat(index) * FullScreenCollectionViewLayout.DRAG_INTERVAL
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        /**
        * Here we target a specific cell index to move towards
        */
        var nextIndex: Int = 0
        let currentY = scrollView.contentOffset.y
        let yDiff: CGFloat = abs(targetContentOffset.memory.y - currentY)
        
        if (velocity.y == 0)
        {
            // A 0 velocity means the user dragged and stopped (no flick)
            // In this case, tell the scroll view to animate to the closest index
            nextIndex = Int(roundf(Float(targetContentOffset.memory.y / FullScreenCollectionViewLayout.DRAG_INTERVAL)))
            targetContentOffset.memory = CGPointMake(0, CGFloat(nextIndex) * FullScreenCollectionViewLayout.DRAG_INTERVAL)
        }
        else if (velocity.y > 0)
        {
            // User scrolled downwards
            // Evaluate to the nearest index
            // Err towards closer a index by forcing a slightly closer target offset
            nextIndex = Int(ceilf(Float((targetContentOffset.memory.y -
                (yDiff * FullScreenPictureVC.DRAG_VELOCITY_DAMPENER))/FullScreenCollectionViewLayout.DRAG_INTERVAL)))
        }
        else
        {
            // User scrolled upwards
            // Evaluate to the nearest index
            // Err towards closer a index by forcing a slightly closer target offset
            nextIndex = Int(floorf(Float((targetContentOffset.memory.y + (yDiff * FullScreenPictureVC.DRAG_VELOCITY_DAMPENER)) / FullScreenCollectionViewLayout.DRAG_INTERVAL)))
        }
    
        // Return our adjusted target point
        targetContentOffset.memory = CGPointMake(0, max(CGFloat(nextIndex) * FullScreenCollectionViewLayout.DRAG_INTERVAL,
        collectionView.contentInset.top))
    }
    
    @IBAction func onSwipedRight(sender: AnyObject) {
        dismiss()
    }

    private func dismiss() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
