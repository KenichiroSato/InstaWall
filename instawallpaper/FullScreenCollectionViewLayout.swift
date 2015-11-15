//
//  FullScreenCollectionViewLayout.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/11/14.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class FullScreenCollectionViewLayout: UICollectionViewLayout {

    static let ACTIVE_HEIGHT: CGFloat = 300.0
    static let DEFAULT_HEIGHT: CGFloat = 10.0
    static let DRAG_INTERVAL: CGFloat = 180.0
    
    private var layoutInfo: [NSIndexPath:UICollectionViewLayoutAttributes] = [:]

    
    override func prepareLayout() {
        super.prepareLayout()
        
        var newLayoutInfo:[NSIndexPath:UICollectionViewLayoutAttributes] = [:]
        let itemCount: Int = collectionView?.numberOfItemsInSection(0) ?? 0
        var indexPath = NSIndexPath(forItem: 0, inSection: 0)
        let contentOffsetTop: CGFloat = collectionView?.contentOffset.y ?? 0
//        NSMutableDictionary *newLayoutInfo = [NSMutableDictionary new];
//        NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
//        CGFloat contentOffsetTop = self.collectionView.contentOffset.y;
        
        let currentIndex: Int = max(Int(contentOffsetTop / FullScreenCollectionViewLayout.DRAG_INTERVAL), 0)
        let currentIndexF: CGFloat = contentOffsetTop / FullScreenCollectionViewLayout.DRAG_INTERVAL
//        int currentIndex = MAX(contentOffsetTop / self.dragInterval, 0);
//        float currentIndexF = contentOffsetTop / self.dragInterval;
        
        // The current 'inbetween' index value. Used to size position the featured cell, and size the incoming cell
        let interpolation: CGFloat = currentIndexF - CGFloat(currentIndex)
//        float interpolation = currentIndexF - currentIndex;
        
        // Holds frame info for the previous calculated cell
        var lastRect: CGRect = CGRectZero
//        CGRect lastRect;
        
        
            
        for item in 0..<itemCount {
//        for (NSInteger item = 0; item < itemCount; item++)

            indexPath = NSIndexPath(forItem: item, inSection: 0)
//            indexPath = [NSIndexPath indexPathForItem:item inSection:0];
            
            let itemAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
//            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            // Cells overlap each other ascending
            itemAttributes.zIndex = item;
            
            var yOffset: CGFloat = 0.0
//            CGFloat yOffset = 0.f;
            
            // The current featured cell
            if (currentIndex == item)
            {
                // Is the content offset past the top inset?
                if (contentOffsetTop > collectionView?.contentInset.top ?? 0)
//                if (contentOffsetTop > self.collectionView.contentInset.top)
                {
                    // Place the feautured cell at the current content offset, and back it off the screen based on how close we are to the next index
                    let yDelta:CGFloat = FullScreenCollectionViewLayout.DEFAULT_HEIGHT * interpolation
                    yOffset = CGFloat(ceil(Double(contentOffsetTop - yDelta)))
//                    CGFloat yDelta = self.defaultHeight * (interpolation);
//                    yOffset = ceilf(contentOffsetTop - yDelta);
                }
                
                // Build that frame, yo! Set the height to the activeHeight value
                itemAttributes.frame = CGRectMake(0, yOffset, collectionView?.bounds.size.width ?? 0, FullScreenCollectionViewLayout.ACTIVE_HEIGHT);
//                itemAttributes.frame = CGRectMake(0, yOffset, self.collectionView.bounds.size.width, self.activeHeight);
                lastRect = itemAttributes.frame;
            }
                // The 'incoming' cell
            else if (item == currentIndex + 1)
            {
                // Calculate how much the cell should 'grow' based on how close it is to becomming featured
                let heightDelta: CGFloat = max((FullScreenCollectionViewLayout.ACTIVE_HEIGHT - FullScreenCollectionViewLayout.DEFAULT_HEIGHT) * interpolation, 0)
                let height: CGFloat = CGFloat(ceil(Double(FullScreenCollectionViewLayout.DEFAULT_HEIGHT + heightDelta)))
                //CGFloat heightDelta = MAX((self.activeHeight - self.defaultHeight) * interpolation, 0);
//                CGFloat height = ceilf(self.defaultHeight + heightDelta);
                
                // Position the BOTTOM of this cell [defaultHeight] pts below the featured cell (lastRect). This is how they visually overlap
                let yOffset: CGFloat = lastRect.origin.y + lastRect.size.height + FullScreenCollectionViewLayout.DEFAULT_HEIGHT - height;
                itemAttributes.frame = CGRectMake(0, yOffset, collectionView?.bounds.size.width ?? 0, height);
                lastRect = itemAttributes.frame;
//                CGFloat yOffset = lastRect.origin.y + lastRect.size.height + self.defaultHeight - height;
//                itemAttributes.frame = CGRectMake(0, yOffset, self.collectionView.bounds.size.width, height);
//                lastRect = itemAttributes.frame;
            }
                // Cells before the current featured cell
            else if (item < currentIndex)
            {
                // Hide that shit offscreen!
                itemAttributes.frame = CGRectMake(0, -5, collectionView?.bounds.size.width ?? 0, 0);
            }
            else
                // Cells beyond the featured/incoming cells
            {
                // Stack it below the last frame
                yOffset = lastRect.origin.y + lastRect.size.height;
                itemAttributes.frame = CGRectMake(0, yOffset, collectionView?.bounds.size.width ?? 0, FullScreenCollectionViewLayout.DEFAULT_HEIGHT);
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
