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
    
    @IBOutlet weak var parentPictureView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomBackground: UIView!
    @IBOutlet weak var topBackground: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tapImageView: UIImageView!
    private var bottomGradientLayer: CAGradientLayer = CAGradientLayer()
    private var topGradientLayer: CAGradientLayer = CAGradientLayer()
    var pictureUrl: NSURL = NSURL(string: DEFAULT_IMAGE_URL + INSTAGRAM_URL_SUFFIX)!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupGradientLayers()
        setImage()
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
        
    private func setImage() {
        let timeTracker = TimeTracker(tag: "setImage")
        timeTracker.start()
        imageView.sd_setImageWithURL(self.pictureUrl)
        if let image = imageView.image {
            updateBackground(image)
        }
        indicatorView.hidden = true
        showTapAnimation()
        timeTracker.finish()
    }
    
    private func showTapAnimation() {
        let ud = NSUserDefaults.standardUserDefaults()
        let hasShown = ud.boolForKey(UserDefaultKey.TAP_ANIMATION_HAS_SHOWN)
        if (!hasShown) {
            self.tapImageView.fadeInAndOut()
            ud.setBool(true, forKey: UserDefaultKey.TAP_ANIMATION_HAS_SHOWN)
        }
    }

    private func imageDataFromURL(url:NSURL) -> NSData? {
        //return NSData(contentsOfURL: url,
        //    options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        return NSData(contentsOfURL: url)
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
    
    private func storeImage(completion:((success:Bool)-> Void)?) {
        let failHandler:((UIAlertAction) -> Void) = { action in
            completion?(success: false)
        }
        let successHandler:(()-> Void) = {
            completion?(success: true)
        }
        
        if (PictureManager.isAuthorizationDenied()) {
            UIAlertController.show(NSLocalizedString("ERR_DENIED_SAVE", comment:""),
                message: nil, forVC: self, handler:failHandler)
            return
        }
        
        if (PictureManager.isAuthorizationNotDetermined()) {
            PictureManager.requestAuthorization(){ authorized in
                if (authorized) {
                    self.storeImage(completion)
                } else {
                    UIAlertController.show(NSLocalizedString("ERR_DENIED_SAVE", comment:""),
                        message: nil, forVC: self, handler:failHandler)
                }
            }
            return
        }
        
        if let image = PictureManager.getImageFromView(parentPictureView) {
            PictureManager.saveImage(image, completion: { success in
                if (success) {
                    if(!PictureManager.firstSavedMessageHasShown()) {
                        self.showFirstSavedMessage(successHandler)
                    } else {
                        successHandler()
                    }
                } else {
                    UIAlertController.show(NSLocalizedString("ERR_FAIL_SAVE", comment:""),
                        message: nil, forVC: self, handler:failHandler)
                }
            })
        } else {
            UIAlertController.show(NSLocalizedString("ERR_FAIL_SAVE", comment:""),
                message: nil, forVC: self, handler:failHandler)
        }
    }
        
    private func showFirstSavedMessage(completion:(()-> Void)) {
        UIAlertController.show(NSLocalizedString("MSG_FIRST_SAVED", comment: ""), message: nil, forVC: self, handler: {action in
            PictureManager.setFirstSavedMessageHasShown()
            completion()
        })
    }
    
    private func showActionMenu() {
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        actionController.popoverPresentationController?.sourceView = self.view
        actionController.popoverPresentationController?.sourceRect =
            CGRectMake(self.view.frame.width/2, self.view.frame.height/2, 200, 300)
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("CANCEL", comment:""),
            style: UIAlertActionStyle.Cancel,
            handler: { action in print("canceled", terminator: "")})
        actionController.addAction(cancelAction)
        
        let showInstruction = UIAlertAction(
            title: NSLocalizedString("MSG_SHOW_INSTRUCTION", comment: ""),
            style: UIAlertActionStyle.Destructive,
            handler: {action in self.showInstruction()})
        actionController.addAction(showInstruction)
        
        let openPhotosAction = UIAlertAction(
            title: NSLocalizedString("MSG_OPEN_PHOTOS", comment:""),
            style: UIAlertActionStyle.Default,
            handler: {action in self.openPhotosApp()})
        actionController.addAction(openPhotosAction)
        
        let backAction = UIAlertAction(
            title: NSLocalizedString("MSG_BACK_TO_LIST", comment: ""),
            style: UIAlertActionStyle.Default,
            handler: {action in self.backToList()})
        actionController.addAction(backAction)
        
        self.presentViewController(actionController, animated: true, completion: nil)
    }
    
    private func showInstruction() {
        performSegueWithIdentifier(SegueIdentifier.SHOW_INSTRUCTION, sender: self)
    }
    
    private func backToList() {
        dismiss()
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

    @IBAction func onTapped(sender: UITapGestureRecognizer) {
        showActionMenu()
    }
    
    @IBAction func onSwiped(sender: AnyObject) {
        dismiss()
    }
    
    private func dismiss() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

