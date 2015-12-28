//
//  ContentBaseVC.swift
//  Photofully
//
//  Created by Kenichiro Sato on 2015/07/15.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class ContentBaseVC: UIViewController {

    static let SEGMENT_ICON_SIZE = CGSizeMake(36, 27)

    @IBOutlet var contentView: UIView!
    
    var photosVC: GridPictureVC!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func shortcutItemType() -> String {
        fatalError("must be overriden")
    }
    
    func iconImage() -> UIImage {
        fatalError("must be overriden")
    }
    
    // This will be called when VC is displayed by using 3D touch shortcut
    func onMovedByShortcut() {
        // add any additional step in subclass
    }
    
    func setupView() {
        if let vc  = self.storyboard?.instantiateViewControllerWithIdentifier("GridPictureVC") as? GridPictureVC {
            photosVC = vc
            self.addChildViewController(photosVC)
            photosVC.didMoveToParentViewController(self)
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
