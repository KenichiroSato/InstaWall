//
//  WelcomeVC.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/12/23.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController, LogInDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        if (AccountManager.sharedInstance.isLoggedIn()) {
            self.performSegueWithIdentifier(SegueIdentifier.SHOW_CONTENT, sender: self)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == SegueIdentifier.LOG_IN) {
            let nextVC = segue.destinationViewController as! LoginVC
            nextVC.logInDelegate = self
        }
    }
    
    // MARK: LogInDelegate
    func onLoggedIn(token: String) {
        AccountManager.sharedInstance.saveToken(token)
        self.performSegueWithIdentifier(SegueIdentifier.SHOW_CONTENT, sender: self)
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
