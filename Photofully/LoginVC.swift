//
//  LoginVC.swift
//  Photofully
//
//  Created by Kenichiro Sato on 2015/06/22.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit
import InstagramKit

protocol LogInDelegate {
    func onLoggedIn(token: String)
}

class LoginVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var eulaPpMessage: EulaPpMessageTextView!
    
    var logInDelegate: LogInDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = false
        webView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        webView.scrollView.bounces = false
        webView.contentMode = UIViewContentMode.ScaleAspectFill
        webView.delegate = self
        
        let authURL:NSURL = InstagramEngine.sharedEngine().authorizarionURLForScope(IKLoginScope.Basic)
        webView.loadRequest(NSURLRequest(URL: authURL))
        
    }
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if let urlString = request.URL?.absoluteString {
            if (urlString.hasPrefix(InstagramEngine.sharedEngine().appRedirectURL)) {
                let delimiter = "access_token="
                let components:Array = urlString.componentsSeparatedByString(delimiter)
                if let token = components.last {
                    if let delegate = logInDelegate {
                        delegate.onLoggedIn(token)
                        logInDelegate = nil
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                return false
            }
        }
        return true
    }
    
    
    @IBAction func onBackPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.hidden = true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        activityIndicator.hidden = true
    }

}
