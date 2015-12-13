//
//  UIViewController+extension.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/12/12.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func dismiss() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

