//
//  ReloadImageView.swift
//  Photofully
//
//  Created by Kenichiro Sato on 2015/09/03.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

protocol TryReloadDelegate {
    func onTryReload()
}

class TryReloadView: UIView {
    
    var reloadDelegate: TryReloadDelegate?
    
    @IBOutlet weak var reloadImage: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customViewCommonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customViewCommonInit()
    }
    
    func customViewCommonInit() {
        let view: UIView  = NSBundle.mainBundle().loadNibNamed("TryReloadView", owner: self, options: nil).first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
    
    @IBAction func onTapped(sender: UITapGestureRecognizer) {
        if let delegate = reloadDelegate {
            delegate.onTryReload()
        }
    }
    
    func hide() {
        self.hidden = true
        reloadImage.hidden = true
        indicator.hidden = true
    }
    
    func showReload() {
        self.hidden = false
        reloadImage.hidden = false
        indicator.hidden = true
    }
    
    func showIndicator() {
        self.hidden = false
        reloadImage.hidden = true
        indicator.hidden = false
    }
}
