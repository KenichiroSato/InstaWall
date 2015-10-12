//
//  HomeContentVC.swift
//  instawallpaper
//
//  Created by 佐藤健一朗 on 2015/07/11.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class HomeContentVC: ContentBaseVC, LogInDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func shortcutItemType() -> String {
        return "type.home"
    }
    
    override func iconImage() -> UIImage {
        return UIImage.named("home", size: ContentBaseVC.SEGMENT_ICON_SIZE)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.backgroundColor = Color.BASE_BLUE
        
        if (AccountManager.sharedInstance.isLoggedIn()) {
            loginButton.setTitle(NSLocalizedString("LOG_OUT", comment:""),
                forState: UIControlState.Normal)
            photosVC.roadTopSelfFeed()
        } else {
            loginButton.setTitle(NSLocalizedString("LOG_IN", comment:""),
                forState: UIControlState.Normal)
            photosVC.roadTopPopular()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (identifier == SegueIdentifier.LOG_IN) {
            if (AccountManager.sharedInstance.isLoggedIn()) {
                logOut()
                return false
            } else {
                return true
            }
        }
        return super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
    }
    
    private func logOut() {
        AccountManager.sharedInstance.logOut()
        loginButton.setTitle(NSLocalizedString("LOG_IN", comment:""),
            forState: UIControlState.Normal)
        photosVC.roadTopPopular()
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
        photosVC.roadTopSelfFeed()
        loginButton.setTitle(NSLocalizedString("LOG_OUT", comment:""),
            forState: UIControlState.Normal)
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
