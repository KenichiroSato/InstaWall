//
//  LoginVC.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/06/22.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

protocol LogInDelegate {
    func onLoggedIn(token: String)
}

class LoginVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var logInDelegate: LogInDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = false
        webView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
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
                    print("token=" + token)
                    self.navigationController?.popViewControllerAnimated(true)
                    if let delegate = logInDelegate {
                        delegate.onLoggedIn(token)
                        logInDelegate = nil
                    }
                }
                return false
            }
        }
        return true
    }
    
    
    @IBAction func onBackPressed(sender: AnyObject) {
        dismiss()
    }
    
    private func dismiss() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.hidden = true
        println("webViewDidFinishLoad")
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        println("start")
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        activityIndicator.hidden = true
        println(error)
    }

}
