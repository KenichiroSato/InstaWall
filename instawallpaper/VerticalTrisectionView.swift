//
//  VerticalTrisectionView.swift
//  instawallpaper
//
//  Created by 佐藤健一朗 on 2015/11/21.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class VerticalTrisectionView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var centerView: UIView!
    
    @IBOutlet weak var bottomVIew: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customViewCommonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customViewCommonInit()
    }
    
    func customViewCommonInit() {
        let view: UIView  = NSBundle.mainBundle().loadNibNamed("VerticalTrisectionView", owner: self, options: nil).first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }

}
