//
//  PhotosCollectionViewController.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/06/13.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

let reuseIdentifier = "PictureCell"

class PhotosCollectionViewController: UICollectionViewController {

    private var pictureArray: [InstagramMedia] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        roadPopularPictures()
    }

    private func roadPopularPictures() {
        let sharedEngine: InstagramEngine = InstagramEngine.sharedEngine()
        sharedEngine.getPopularMediaWithSuccess(
            { (media, paginationInfo) in
                if let pictures = media as? [InstagramMedia] {
                    self.pictureArray.removeAll(keepCapacity: false)
                    self.pictureArray += pictures
                    self.refreshCollectionViewData()
                }
            },
            failure: {error, statusCode in
                println("failure")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    private func refreshCollectionViewData() {
        self.collectionView?.reloadData()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PictureCell
    
        if (pictureArray.count >= indexPath.row + 1) {
            let media: InstagramMedia = pictureArray[indexPath.row]
            cell.imageView.setImageWithURL(media.thumbnailURL)
        } else {
            cell.imageView.setImageWithURL(nil)
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

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
