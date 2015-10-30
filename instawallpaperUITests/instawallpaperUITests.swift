//
//  instawallpaperUITests.swift
//  instawallpaperUITests
//
//  Created by 佐藤健一朗 on 2015/10/29.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import XCTest

class instawallpaperUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // 1. tap Login button
    // 2. back to list by tapping back button
    func testLogin() {
        let app = XCUIApplication()
        app.scrollViews.otherElements.buttons["Login"].tap()
        app.buttons["back"].tap()
        
    }
    
    
    // 1. move to search list
    // 2. tap seach box
    // 3. enter cat
    func testSearchItem() {
        
        let app = XCUIApplication()
        app.otherElements.containingType(.NavigationBar, identifier:"instawallpaper.SegmentedVC").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.ScrollView).element.tap()
        
        let elementsQuery = app.scrollViews.otherElements
        let searchKeywordTextField = elementsQuery.textFields["search keyword"]
        searchKeywordTextField.tap()
        elementsQuery.buttons["Clear text"].tap()
        searchKeywordTextField.typeText("cat")
        app.typeText("\r")
        
    }
    
    
    
}
