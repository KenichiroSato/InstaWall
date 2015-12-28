//
//  VerticalTrisectionView.swift
//  Photofully
//
//  Created by Kenichiro Sato on 2015/11/21.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class GradationView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    private let ANIMATION_DURATION = 0.8
    
    private var gradientLayer: CAGradientLayer = CAGradientLayer()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let view: UIView  = NSBundle.mainBundle()
            .loadNibNamed("GradationView", owner: self, options: nil).first as! UIView
        view.frame = CGRectMake(0, 0, Screen.WIDTH(), Screen.HEIGHT())
        addSubview(view)
        
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
    }

    func updateTopColor(topColor:UIColor, andBottomColor bottomColor:UIColor) {
        UIView.animateWithDuration(ANIMATION_DURATION, animations: { () -> Void in
            self.gradientLayer.colors =
                   [topColor.CGColor,
                    topColor.CGColor,
                    topColor.CGColor,
                    bottomColor.CGColor,
                    bottomColor.CGColor,
                    bottomColor.CGColor]
        })
    }
}
