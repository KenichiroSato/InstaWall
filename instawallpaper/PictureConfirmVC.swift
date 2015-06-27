//
//  ViewController.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/05/30.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class PictureConfirmVC: UIViewController {

    static private let DEFAULT_IMAGE_URL = "https://instagram.com/p/3k7-yGxmzD/"
    //static private let DEFAULT_IMAGE_URL = "https://instagram.com/p/3iIhzJRm5s/"
    //static private let DEFAULT_IMAGE_URL = "https://instagram.com/p/3jLlOoTf5t/"
    //static private let DEFAULT_IMAGE_URL = "https://instagram.com/p/3iqc5aRi-0/"
    //static private let DEFAULT_IMAGE_URL = "https://instagram.com/p/3hJGONxOcG/"
    //static private let DEFAULT_IMAGE_URL = "https://instagram.com/p/pRTKnyGLtp/"
    
    static private let INSTAGRAM_URL_SUFFIX = "media?size=l"
    
    static private let PHOTOS_APP_URL_SCHEME = "photos-redirect:"
    
    static private let GRADATION_HEIGHT: CGFloat = 20.0
    
    @IBOutlet weak var urlTextFIeld: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var parentPictureView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomBackground: UIView!
    @IBOutlet weak var topBackground: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    private var bottomGradientLayer: CAGradientLayer = CAGradientLayer()
    private var topGradientLayer: CAGradientLayer = CAGradientLayer()
    var pictureUrl: NSURL = NSURL(string: DEFAULT_IMAGE_URL + INSTAGRAM_URL_SUFFIX)!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupGradientLayers()
        urlTextFIeld.resignFirstResponder()
        setImage()
        indicatorView.hidden = true
    }
    
    private func setupGradientLayers() {
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        
        var topFrame: CGRect = imageView.bounds
        topFrame.size.height = PictureConfirmVC.GRADATION_HEIGHT
        topFrame.size.width = screenWidth
        topGradientLayer.frame = topFrame
        imageView.layer.addSublayer(topGradientLayer)

        var bottomFrame: CGRect = imageView.bounds
        bottomFrame.size.height = PictureConfirmVC.GRADATION_HEIGHT
        bottomFrame.origin.y = screenWidth  - PictureConfirmVC.GRADATION_HEIGHT
        bottomFrame.size.width = screenWidth
        bottomGradientLayer.frame = bottomFrame
        imageView.layer.addSublayer(bottomGradientLayer)        
    }
    
    @IBAction func onGoButtonClicked(sender: AnyObject) {
        urlTextFIeld.resignFirstResponder() // close keyborad
        let text = urlTextFIeld.text
        if (text.isEmpty) {
            UIAlertController.show(Text.ERR_EPTRY_URL, message: nil, forVC: self)
            return
        }
        if let url = NSURL(string: text + PictureConfirmVC.INSTAGRAM_URL_SUFFIX) {
            pictureUrl = url
            setImage()
        } else {
            UIAlertController.show(Text.ERR_INVALID_URL, message: nil, forVC: self)
        }
    }
    
    private func setImage() {
        let timeTracker = TimeTracker(tag: "setImage")
        timeTracker.start()
        if let imageData = imageDataFromURL(pictureUrl),
            img = UIImage(data:imageData) {
                imageView.image = img
                updateBackground(img)
        } else {
            UIAlertController.show(Text.ERR_INVALID_URL, message: nil, forVC: self)
        }
        timeTracker.finish()
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
            PictureManager.saveImage(image, completion: { result in print("saved!!")})
        } else {
            PictureManager.requestAnthorization()
        }
    }
    
    @IBAction func onTapped(sender: UITapGestureRecognizer) {
        showSaveMenu()
    }
    
    private func showSaveMenu() {
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancelAction = UIAlertAction(title: Text.CANCEL, style: UIAlertActionStyle.Cancel, handler: { action in print("canceled")})
        let saveAction = UIAlertAction(title: Text.MSG_SAVE, style: UIAlertActionStyle.Default, handler: {action in self.storeImage()})
        let saveAndOpenAction = UIAlertAction(title: Text.MSG_SAVE_AND_OPEN_PHOTOS, style: UIAlertActionStyle.Default, handler: {action in
            self.storeImage()
            self.openPhotosApp()
        })
        actionController.addAction(cancelAction)
        actionController.addAction(saveAction)
        actionController.addAction(saveAndOpenAction)
        self.presentViewController(actionController, animated: true, completion: nil)
    }
    
    private func openPhotosApp() {
        if let url = NSURL(string: PictureConfirmVC.PHOTOS_APP_URL_SCHEME) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onBackPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

