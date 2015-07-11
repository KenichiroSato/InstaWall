//
//  HomeContentVC.swift
//  instawallpaper
//
//  Created by 佐藤健一朗 on 2015/07/11.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class HomeContentVC: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        bottomView.backgroundColor = Color.BASE_BLUE
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PhotosCollectionVC") as? PhotosCollectionVC {
            self.addChildViewController(vc)
            vc.didMoveToParentViewController(self)
            vc.collectionView?.dataSource = vc
            vc.collectionView?.delegate = vc
            vc.view.frame.size = contentView.frame.size
            if let view = vc.view {
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
