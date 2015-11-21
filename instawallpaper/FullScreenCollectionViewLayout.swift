//
//  FullScreenCollectionViewLayout.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/11/14.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class FullScreenCollectionViewLayout: UICollectionViewLayout {

    static let DEFAULT_CELL_HEIGHT: CGFloat = 300.0
    static let DRAG_INTERVAL: CGFloat = 180.0
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    
    private var layoutInfo: [NSIndexPath:UICollectionViewLayoutAttributes] = [:]
    
    override func prepareLayout() {
        super.prepareLayout()

        var newLayoutInfo:[NSIndexPath:UICollectionViewLayoutAttributes] = [:]
        let itemCount: Int = collectionView?.numberOfItemsInSection(0) ?? 0
        var indexPath = NSIndexPath(forItem: 0, inSection: 0)
        let contentOffsetTop: CGFloat = collectionView?.contentOffset.y ?? 0
        
        let currentIndex: Int = max(Int(contentOffsetTop / FullScreenCollectionViewLayout.DRAG_INTERVAL), 0)
        let currentIndexF: CGFloat = contentOffsetTop / FullScreenCollectionViewLayout.DRAG_INTERVAL
        
        // The current 'inbetween' index value. Used to size position the featured cell, and size the incoming cell
        let interpolation: CGFloat = currentIndexF - CGFloat(currentIndex)
        
        // Holds frame info for the previous calculated cell
        var lastRect: CGRect = CGRectZero
        
        for item in 0..<itemCount {

            indexPath = NSIndexPath(forItem: item, inSection: 0)
            let itemAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)

            // Cells overlap each other ascending
            itemAttributes.zIndex = item;
            
            var yOffset: CGFloat = 0.0
           
            let cellHeight: CGFloat
            if let dataSource = collectionView?.dataSource as? FullScreenPictureDataSource,
                let height = dataSource.heightOfCellAtIndex(item) {
                    cellHeight = height
            } else {
                cellHeight = FullScreenCollectionViewLayout.DEFAULT_CELL_HEIGHT
            }
            
            // The current featured cell
            if (currentIndex == item)
            {
                yOffset = CGFloat(ceil(contentOffsetTop) + SCREEN_HEIGHT/2 - cellHeight/2)
                itemAttributes.frame = CGRectMake(0, yOffset, SCREEN_WIDTH, cellHeight);
                itemAttributes.alpha = 1 - interpolation
                lastRect = itemAttributes.frame;
            }
            // The 'incoming' cell
            else if (item == currentIndex + 1)
            {
                // Calculate how much the cell should 'grow' based on how close it is to becomming featured
                let heightDelta: CGFloat = max(cellHeight * interpolation, 0)
                let height: CGFloat = CGFloat(ceil(heightDelta))
                
                // Position the BOTTOM of this cell [defaultHeight] pts below the featured cell (lastRect).
                // This is how they visually overlap
                let yOffsetDelat: CGFloat = (cellHeight/2 - lastRect.size.height/2) * interpolation
                let yOffset: CGFloat = lastRect.origin.y + lastRect.size.height - height + yOffsetDelat;
                itemAttributes.frame = CGRectMake(0, yOffset, SCREEN_WIDTH, height);
                itemAttributes.alpha = interpolation
                lastRect = itemAttributes.frame;
            }
            // Cells before the current featured cell
            else if (item < currentIndex)
            {
                // Hide that shit offscreen!
                itemAttributes.frame = CGRectMake(0, -5, SCREEN_WIDTH, 0);
            }
            else
                // Cells beyond the featured/incoming cells
            {
                // Stack it below the last frame
                yOffset = lastRect.origin.y + lastRect.size.height;
                itemAttributes.frame = CGRectMake(0, yOffset, SCREEN_WIDTH, 0);
                lastRect = itemAttributes.frame;
            }
            
            // Store the itemAttributes
            newLayoutInfo[indexPath] = itemAttributes;
        }
        
        // Store all the new layoutAttributes
        self.layoutInfo = newLayoutInfo;
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var allAttributes:[UICollectionViewLayoutAttributes] = []
        for (_, attributes) in layoutInfo {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                allAttributes += [attributes]
            }
        }
        return allAttributes;
    }
    
    override func collectionViewContentSize() -> CGSize {
        if let items = self.collectionView?.numberOfItemsInSection(0),
            let width = collectionView?.bounds.size.width,
            let height = collectionView?.bounds.size.height {
                let size:CGSize = CGSize(width: width,
            height: (CGFloat(items) * FullScreenCollectionViewLayout.DRAG_INTERVAL) + (height - FullScreenCollectionViewLayout.DRAG_INTERVAL))
                return size
        } else {
            //warning
            return CGSize(width: 100, height: 100)
        }
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutInfo[indexPath]
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

}
