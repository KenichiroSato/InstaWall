//
//  LoginVC.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/06/22.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
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
                    InstagramEngine.sharedEngine().accessToken = token
                    self.dismissViewControllerAnimated(true, completion: {})
                }
                return false
            }
        }
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        println("webViewDidFinishLoad")
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        println("start")
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        println(error)
    }

}
