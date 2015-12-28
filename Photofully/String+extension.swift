//
//  String+extension.swift
//  Photofully
//
//  Created by Kenichiro Sato on 2015/07/21.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation

extension String {

    func removeSpace() -> String {
        return self.stringByReplacingOccurrencesOfString(" ", withString: "", options: [], range: nil)
    }
}