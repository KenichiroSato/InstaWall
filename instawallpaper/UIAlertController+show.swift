//
//  UIAlertController+show.swift
//  instawallpaper
//
//  Created by Kenichiro on 2015/06/21.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func show(title:String, message:String?, forVC vc:UIViewController, handler:((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message,
            preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment:""),
            style: .Default, handler:handler)
        alertController.addAction(okAction)
        dispatch_async(dispatch_get_main_queue(), {
            vc.presentViewController(alertController, animated: true, completion: nil)
        })
    }

}