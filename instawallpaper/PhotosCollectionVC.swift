//
//  PhotosCollectionViewController.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/06/13.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

let reuseIdentifier = "PictureCell"

class PhotosCollectionVC: UICollectionViewController {

    private var pictureArray: [InstagramMedia] = []
    private var paginationInfo: InstagramPaginationInfo? = nil
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        roadPopularPictures()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false        
    }

    private func roadPopularPictures() {
        prepareLoadingData()
        let sharedEngine: InstagramEngine = InstagramEngine.sharedEngine()
        sharedEngine.getPopularMediaWithSuccess(
            { (media, paginationInfo) in
                self.paginationInfo = paginationInfo
                if let pictures = media as? [InstagramMedia] {
                    self.pictureArray.removeAll(keepCapacity: false)
                    self.pictureArray += pictures
                    self.finishLoadingData()
                }
            },
            failure: {error, statusCode in
                print("failure")
        })
    }
    
    private func roadFromText(text: String) {
        prepareLoadingData()
        let sharedEngine: InstagramEngine = InstagramEngine.sharedEngine()
        sharedEngine.getMediaWithTagName(text, count: 50, maxId: self.paginationInfo?.nextMaxId, withSuccess: { (media, paginationInfo) in
            self.paginationInfo = paginationInfo
            if let pictures = media as? [InstagramMedia] {
                self.pictureArray += pictures
                self.finishLoadingData()
            }
        }, failure: {error, statusCode in
                print("failure")
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segue.fullscreen") {
            let nextVC = segue.destinationViewController as! PictureConfirmVC
            if let selectedItems  = self.collectionView?.indexPathsForSelectedItems(){
                let selectedIndexPath = selectedItems[0]
                let media: InstagramMedia = pictureArray[selectedIndexPath.item];
                nextVC.pictureUrl = media.standardResolutionImageURL
            }
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
    
    // MARK - UITextFieldDelegate methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = textField.text {
            roadFromText(text)
        }
        textField.resignFirstResponder()
        return true
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
