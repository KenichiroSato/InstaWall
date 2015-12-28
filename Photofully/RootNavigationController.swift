//
//  RootNavigationController.swift
//  Photofully
//
//  Created by Kenichiro Sato on 2015/12/27.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {

    private let ID_WELCOME = "WelcomeVC"
    private let ID_CONTENT = "SegmentedVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVCs()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupVCs() {
        let storyboard:UIStoryboard =  UIStoryboard(name: "Main",bundle:nil)
        
        var ids = [ID_WELCOME]
        if (AccountManager.sharedInstance.isLoggedIn()) {
            ids += [ID_CONTENT]
        }
        for id in ids {
            let vc = storyboard.instantiateViewControllerWithIdentifier(id) as UIViewController
            self.pushViewController(vc, animated: false)
        }
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
