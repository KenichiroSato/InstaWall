//
//  EulePpMessageTextView.swift
//  Photofully
//
//  Created by Kenichiro Sato on 2015/12/26.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class EulaPpMessageTextView: LinkTextView {

    private let EULA_URL = "https://www.instagram.com/about/legal/terms/"
    private let PP_URL = "https://www.instagram.com/about/legal/privacy/"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextView()
    }

    private func setupTextView() {
        self.text = String(format: Text.MSG_PP_EULA,
            arguments: [Text.PRIVACY_POLICY, Text.EULA])
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.blueColor(),
            LinkTextView.LinkKey: "linked",
        ]
        
        let string = attributedText.string
        let mutableAttributedString = attributedText.mutableCopy() as! NSMutableAttributedString
        
        let ppRange = (string as NSString).rangeOfString(Text.PRIVACY_POLICY)
        mutableAttributedString.addAttributes(attributes, range: ppRange)
        let eulaRange = (string as NSString).rangeOfString(Text.EULA)
        mutableAttributedString.addAttributes(attributes, range: eulaRange)
        attributedText = mutableAttributedString
        linkClickedBlock = { (string: String) in
            if let openUrl = self.linkUrl(string) {
                UIApplication.sharedApplication().openURL(openUrl)
            }
        }
    }
    
    private func linkUrl(string: String) -> NSURL? {
        var url: NSURL? = nil
        if (string == Text.PRIVACY_POLICY) {
            url = NSURL(string:self.PP_URL)
        } else if (string == Text.EULA) {
            url = NSURL(string:self.EULA_URL)
        }
        return url
    }
}
