//
//  AccountManager.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/07/04.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation

public class AccountManager {

    static private let KEY_TOKEN = "token"
    
    static let sharedInstance = AccountManager()

    func saveToken(token:String) {
        InstagramEngine.sharedEngine().accessToken = token
        
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(token, forKey: AccountManager.KEY_TOKEN)
    }
    
    // load token from storage and set it to InstagramEngine
    func loadToken() {
        let ud = NSUserDefaults.standardUserDefaults()
        if let token = ud.objectForKey(AccountManager.KEY_TOKEN) as? String {
            InstagramEngine.sharedEngine().accessToken = token
        }
    }

    func isLoggedIn() -> Bool {
        if let token = InstagramEngine.sharedEngine().accessToken {
            return true
        } else {
            return false
        }
    }
}