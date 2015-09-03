//
//  ReloadImageView.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/09/03.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class ReloadImageView: UIView {
    
    class func instance() -> ReloadImageView {
        return UINib(nibName: "ReloadImageView", bundle: nil)
            .instantiateWithOwner(self, options: nil)[0] as! ReloadImageView
    }
    
    @IBAction func onTapped(sender: UITapGestureRecognizer) {
        println("ontapped")
    }
}
