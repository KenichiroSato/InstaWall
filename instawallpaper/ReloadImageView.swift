//
//  ReloadImageView.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/09/03.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class ReloadImageView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customViewCommonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customViewCommonInit()
    }
    
    func customViewCommonInit() {
        let view: UIView  = NSBundle.mainBundle().loadNibNamed("ReloadImageView", owner: self, options: nil).first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
    
    @IBAction func onTapped(sender: UITapGestureRecognizer) {
        println("ontapped")
    }
}
