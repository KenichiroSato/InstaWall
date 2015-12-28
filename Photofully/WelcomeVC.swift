//
//  WelcomeVC.swift
//  Photofully
//
//  Created by Kenichiro Sato on 2015/12/23.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController, LogInDelegate {
    
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextLabels()

        if (AccountManager.sharedInstance.isLoggedIn()) {
            self.performSegueWithIdentifier(SegueIdentifier.SHOW_CONTENT, sender: self)
        }
    }
    
    private func setupTextLabels() {
        welcomeText.text = Text.APP_NAME
        welcomeText.textColor = Color.BASE_BLUE
        loginButton.setTitle(Text.LOG_IN, forState: UIControlState.Normal)
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
        UIView.setAnimationsEnabled(false)
        self.performSegueWithIdentifier(SegueIdentifier.SHOW_CONTENT, sender: self)
        UIView.setAnimationsEnabled(true)
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
