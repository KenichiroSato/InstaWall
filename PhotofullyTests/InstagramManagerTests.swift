//
//  InstagramManagerTests.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/12/04.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import XCTest
@testable import Photofully

class InstagramManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOpenInstagramApp() {
        XCTAssertFalse(InstagramManager.openInstagramApp(""))
        XCTAssertFalse(InstagramManager.openInstagramApp("aaa"))

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
        
}
