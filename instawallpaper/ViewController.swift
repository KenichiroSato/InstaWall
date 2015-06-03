//
//  ViewController.swift
//  instawallpaper
//
//  Created by 佐藤健一朗 on 2015/05/30.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    static private let DEFAULT_IMAGE_URL = "http://ecx.images-amazon.com/images/I/71HH7D7Z66L._SX425_.jpg"
    
    static private let GRADATION_HEIGHT: CGFloat = 20.0
    
    @IBOutlet weak var urlTextFIeld: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomBackground: UIView!
    @IBOutlet weak var topBackground: UIView!
    var bottomGradientLayer: CAGradientLayer = CAGradientLayer()
    var topGradientLayer: CAGradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextFIeld.text = ViewController.DEFAULT_IMAGE_URL
        setupGradientLayers()
    }
    
    private func setupGradientLayers() {
        var topFrame: CGRect = imageView.bounds
        topFrame.size.height = ViewController.GRADATION_HEIGHT
        topGradientLayer.frame = topFrame
        imageView.layer.addSublayer(topGradientLayer)

        var bottomFrame: CGRect = imageView.bounds
        bottomFrame.size.height = ViewController.GRADATION_HEIGHT
        bottomFrame.origin.y = imageView.bounds.size.height - ViewController.GRADATION_HEIGHT
        bottomGradientLayer.frame = bottomFrame
        imageView.layer.addSublayer(bottomGradientLayer)
    }
    
    @IBAction func onGoButtonClicked(sender: AnyObject) {
        if let url = NSURL(string: urlTextFIeld.text) {
            setImage(url)
        }
    }
    
    private func setImage(url:NSURL) {
        if let imageData = imageDataFromURL(url),
            img = UIImage(data:imageData) {
                imageView.image = img
                updateBackground(img)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

