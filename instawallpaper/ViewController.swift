//
//  ViewController.swift
//  instawallpaper
//
//  Created by 佐藤健一朗 on 2015/05/30.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    static private let DEFAULT_IMAGE_URL = "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/11378548_441947802652148_854370825_n.jpg"
    
    @IBOutlet weak var urlTextFIeld: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextFIeld.text = ViewController.DEFAULT_IMAGE_URL
    }
    
    private func setImage(url:NSURL) {
        if let imageData = imageDataFromURL(url),
            img = UIImage(data:imageData) {
                imageView.image = img
        }
    }
    
    private func imageDataFromURL(url:NSURL) -> NSData? {
        return NSData(contentsOfURL: url,
            options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
    }
    
    @IBAction func onGoButtonClicked(sender: AnyObject) {
        if let url = NSURL(string: urlTextFIeld.text) {
            setImage(url)
            if let image = imageView.image {
                let backColor = ImageUtil.mostFrequentColor(image, position: ImageUtil.Position.BOTTOM)
                self.view.backgroundColor = backColor
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

