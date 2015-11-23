//
//  FullScreenOverlayView.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/11/23.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class FullScreenOverlayView: UIView {

    private let GRADATION_HEIGHT: CGFloat = 20.0
    private let ANIMATION_DURATION = 0.4

    private var topGradientView: UIView!
    private var bottomGradientView: UIView!
    private var topGradientLayer: CAGradientLayer = CAGradientLayer()
    private var bottomGradientLayer: CAGradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        topGradientView = UIView(frame: frame)
        topGradientView.frame.size.height = GRADATION_HEIGHT
        topGradientView.layer.addSublayer(topGradientLayer)
        topGradientLayer.frame = topGradientView.bounds
        addSubview(topGradientView)
        
        bottomGradientView = UIView(frame: frame)
        bottomGradientView.frame.size.height = GRADATION_HEIGHT
        bottomGradientLayer.frame = bottomGradientView.bounds
        bottomGradientView.layer.addSublayer(bottomGradientLayer)
        addSubview(bottomGradientView)
    }
    
    func hideGradientViews() {
        UIView.animateWithDuration(ANIMATION_DURATION, animations: { () -> Void in
            self.topGradientView.alpha = 0.0
            self.bottomGradientView.alpha = 0.0
        })
    }

    private func showGradientViews() {
        UIView.animateWithDuration(ANIMATION_DURATION, animations: { () -> Void in
            self.topGradientView.alpha = 1.0
            self.bottomGradientView.alpha = 1.0
        })
    }
    
    func updateGradientViews(contentHeight: CGFloat, topColor: UIColor, bottomColor: UIColor) {
        updateGradienViewFrame(contentHeight)
        updateGradientLayer(topColor, bottomColor: bottomColor)
        showGradientViews()
    }
    
    private func updateGradienViewFrame(contentHeight: CGFloat) {
        var topFrame = topGradientView.frame
        topFrame.origin.y = Screen.HEIGHT() / 2 - contentHeight / 2
        topGradientView.frame = topFrame
        
        
        var bottomFrame = bottomGradientView.frame
        bottomFrame.origin.y = Screen.HEIGHT() / 2 + contentHeight / 2 - GRADATION_HEIGHT
        bottomGradientView.frame = bottomFrame
    }
    
    private func updateGradientLayer(topColor: UIColor, bottomColor: UIColor) {
        let topEndColor = topColor.colorWithAlphaComponent(0.0)
        topGradientLayer.colors = [topColor.CGColor, topEndColor.CGColor]
        
        let bottomStartColor = bottomColor.colorWithAlphaComponent(0.0)
        bottomGradientLayer.colors = [bottomStartColor.CGColor, bottomColor.CGColor]
    }

    // pass touch event to underlying views
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        return nil
        /*
        let view = super.hitTest(point, withEvent: event)
        if (view == self) {
            return nil
        }
        return view
        */
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
