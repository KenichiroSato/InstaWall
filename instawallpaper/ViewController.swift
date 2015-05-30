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
        urlTextFIeld.placeholder = "enter URL here!"
        setDefaultImage()
    }

    private func setDefaultImage() {
        //imageView.frame = CGRectMake(0, 0, 120, 120);
        imageView.backgroundColor = UIColor.greenColor()
        let url = NSURL(string: ViewController.DEFAULT_IMAGE_URL)
        var err: NSError?;
        var imageData :NSData = NSData(contentsOfURL: url!,
            options: NSDataReadingOptions.DataReadingMappedIfSafe,
            error: &err)!;
        var img = UIImage(data:imageData);
        imageView.image = img

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

