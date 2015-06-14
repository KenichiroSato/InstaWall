//
//  ViewController.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/05/30.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    static private let DEFAULT_IMAGE_URL = "https://instagram.com/p/3k7-yGxmzD/"
    //static private let DEFAULT_IMAGE_URL = "https://instagram.com/p/3iIhzJRm5s/"
    //static private let DEFAULT_IMAGE_URL = "https://instagram.com/p/3jLlOoTf5t/"
    //static private let DEFAULT_IMAGE_URL = "https://instagram.com/p/3iqc5aRi-0/"
    //static private let DEFAULT_IMAGE_URL = "https://instagram.com/p/3hJGONxOcG/"
    //static private let DEFAULT_IMAGE_URL = "https://instagram.com/p/pRTKnyGLtp/"
    
    static private let INSTAGRAM_URL_SUFFIX = "media?size=l"
    
    static private let GRADATION_HEIGHT: CGFloat = 20.0
    
    @IBOutlet weak var urlTextFIeld: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var parentPictureView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomBackground: UIView!
    @IBOutlet weak var topBackground: UIView!
    private var bottomGradientLayer: CAGradientLayer = CAGradientLayer()
    private var topGradientLayer: CAGradientLayer = CAGradientLayer()
    var openUrl = NSURL(string: ViewController.DEFAULT_IMAGE_URL + ViewController.INSTAGRAM_URL_SUFFIX)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayers()
        urlTextFIeld.resignFirstResponder()
        setImage()
    }
    
    private func setupGradientLayers() {
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        
        var topFrame: CGRect = imageView.bounds
        topFrame.size.height = ViewController.GRADATION_HEIGHT
        topFrame.size.width = screenWidth
        topGradientLayer.frame = topFrame
        imageView.layer.addSublayer(topGradientLayer)

        var bottomFrame: CGRect = imageView.bounds
        bottomFrame.size.height = ViewController.GRADATION_HEIGHT
        bottomFrame.origin.y = screenWidth  - ViewController.GRADATION_HEIGHT
        bottomFrame.size.width = screenWidth
        bottomGradientLayer.frame = bottomFrame
        imageView.layer.addSublayer(bottomGradientLayer)        
    }
    
    @IBAction func onGoButtonClicked(sender: AnyObject) {
        urlTextFIeld.resignFirstResponder() // close keyborad
        if let url = NSURL(string: urlTextFIeld.text + ViewController.INSTAGRAM_URL_SUFFIX) {
            openUrl = url
            setImage()
        }
    }
    
    private func setImage() {
        if let url = openUrl {
            let timeTracker = TimeTracker(tag: "setImage")
            timeTracker.start()
            if let imageData = imageDataFromURL(url),
                img = UIImage(data:imageData) {
                    imageView.image = img
                    updateBackground(img)
                    storeImage()
            }
            timeTracker.finish()
        }
    }
    
    private func imageDataFromURL(url:NSURL) -> NSData? {
        return NSData(contentsOfURL: url,
            options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
    }
    
    private func updateBackground(image: UIImage) {
        updateTopBackground(image)
        updateBottomBackground(image)
    }
    
    private func updateTopBackground(image: UIImage) {
        let backColor = ImageUtil.mostFrequentColor(image, position: ImageUtil.Position.TOP)
        topBackground.backgroundColor = backColor
        
        let startColor  = backColor
        let endColor = backColor.colorWithAlphaComponent(0.0)
        topGradientLayer.colors = [startColor.CGColor, endColor.CGColor]
    }
    
    private func updateBottomBackground(image: UIImage) {
        let backColor = ImageUtil.mostFrequentColor(image, position: ImageUtil.Position.BOTTOM)
        bottomBackground.backgroundColor = backColor

        let startColor  = backColor.colorWithAlphaComponent(0.0)
        let endColor = backColor
        bottomGradientLayer.colors = [startColor.CGColor, endColor.CGColor]
    }
    
    private func storeImage() {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        //self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
        parentPictureView.layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (PictureManager.isAuthorized()) {
            PictureManager.saveImage(image, completion: { result in
                println("saved!!")
            })
        } else {
            PictureManager.requestAnthorization()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

