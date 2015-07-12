//
//  SearchContentVC.swift
//  instawallpaper
//
//  Created by 佐藤健一朗 on 2015/07/11.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class SearchContentVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var searchBox: UITextField!
    
    var photosVC: PhotosCollectionVC!

    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.backgroundColor = Color.BASE_BLUE
        setupView()
    }

    private func setupView() {
        bottomView.backgroundColor = Color.BASE_BLUE
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
    
    // MARK - UITextFieldDelegate methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = textField.text {
            photosVC.roadFromText(text)
        }
        textField.resignFirstResponder()
        return true
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
