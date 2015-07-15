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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.backgroundColor = Color.BASE_BLUE
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segue.login") {
            let nextVC = segue.destinationViewController as! LoginVC
            nextVC.logInDelegate = self
        }
    }

    // MARK: LogInDelegate
    func onLoggedIn(token: String) {
        AccountManager.sharedInstance.saveToken(token)
        photosVC.roadTopSelfFeed()
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
