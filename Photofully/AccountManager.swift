//
//  AccountManager.swift
//  Photofully
//
//  Created by Kenichiro Sato on 2015/07/04.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation
import InstagramKit

public class AccountManager {

    
    static let sharedInstance = AccountManager()

    func saveToken(token:String) {
        InstagramEngine.sharedEngine().accessToken = token
        
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(token, forKey: UserDefaultKey.INSTAGRAM_TOKEN)
    }
    
    // load token from storage and set it to InstagramEngine
    func loadToken() {
        let ud = NSUserDefaults.standardUserDefaults()
        if let token = ud.objectForKey(UserDefaultKey.INSTAGRAM_TOKEN) as? String {
            InstagramEngine.sharedEngine().accessToken = token
        }
    }
    
    func logOut() {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.removeObjectForKey(UserDefaultKey.INSTAGRAM_TOKEN)
        InstagramEngine.sharedEngine().logout()
    }

    func isLoggedIn() -> Bool {
        return (InstagramEngine.sharedEngine().accessToken != nil)
    }
}