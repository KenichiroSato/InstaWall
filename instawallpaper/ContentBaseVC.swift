//
//  ContentBaseVC.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/07/15.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class ContentBaseVC: UIViewController {

    @IBOutlet var contentView: UIView!
    
    var photosVC: PhotosCollectionVC!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func shortcutItemType() -> String {
        fatalError("must be overriden")
    }
    
    func setupView() {
        if let vc  = self.storyboard?.instantiateViewControllerWithIdentifier("PhotosCollectionVC") as? PhotosCollectionVC {
            photosVC = vc
            self.addChildViewController(photosVC)
            photosVC.didMoveToParentViewController(self)
            photosVC.collectionView?.dataSource = photosVC
            photosVC.collectionView?.delegate = photosVC
            photosVC.view.frame.size = contentView.frame.size
            if let view = photosVC.view {
                contentView.addSubview(view)
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
