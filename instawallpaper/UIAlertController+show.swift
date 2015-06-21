//
//  UIAlertController+show.swift
//  instawallpaper
//
//  Created by Kenichiro on 2015/06/21.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func show(title:String, message:String?, forVC vc:UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: Text.OK, style: .Default, handler:nil)
        alertController.addAction(okAction)
        vc.presentViewController(alertController, animated: true, completion: nil)
    }

}