//
//  instawallpaper_UI_Tests.swift
//  instawallpaper UI Tests
//
//  Created by 佐藤健一朗 on 2015/06/20.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation
import XCTest

class instawallpaper_UI_Tests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let app = XCUIApplication()
        sleep(5)
        app.collectionViews.childrenMatchingType(.Cell).elementAtIndex(0).descendantsMatchingType(.Unknown).childrenMatchingType(.Image).elementAtIndex(0).tap()
        sleep(5)
        app.buttons["Back"].tap()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testErrorDialog() {
        let app = XCUIApplication()
        sleep(5)
        app.collectionViews.childrenMatchingType(.Cell).elementAtIndex(0).descendantsMatchingType(.Unknown).childrenMatchingType(.Image).elementAtIndex(0).tap()
        let goButton = app.buttons["GO"]
        goButton.tap()
        app.alerts[Text.ERR_EPTRY_URL].collectionViews.buttons[Text.OK].tap()
        
        let textField = app.childrenMatchingType(.Window).elementAtIndex(0).childrenMatchingType(.Unknown).elementAtIndex(0).childrenMatchingType(.Unknown).elementAtIndex(0).childrenMatchingType(.Unknown).elementAtIndex(0).childrenMatchingType(.Unknown).elementAtIndex(0).childrenMatchingType(.Unknown).elementAtIndex(2).childrenMatchingType(.TextField).elementAtIndex(0)
        textField.tap()
        textField.typeText("test")
        
        goButton.tap()
        app.alerts[Text.ERR_INVALID_URL].collectionViews.buttons[Text.OK].tap()
    }
    
    func testSaveImage() {
        let app = XCUIApplication()
        sleep(5)
        app.collectionViews.childrenMatchingType(.Cell).elementAtIndex(8).descendantsMatchingType(.Unknown).childrenMatchingType(.Image).elementAtIndex(0).tap()
        app.childrenMatchingType(.Window).elementAtIndex(0).childrenMatchingType(.Unknown).elementAtIndex(0).childrenMatchingType(.Unknown).elementAtIndex(0).childrenMatchingType(.Unknown).elementAtIndex(0).childrenMatchingType(.Unknown).elementAtIndex(0).childrenMatchingType(.Unknown).elementAtIndex(1).childrenMatchingType(.Image).elementAtIndex(0).tap()
        app.sheets.collectionViews.buttons["Save"].tap()
        app.buttons["Back"].tap()
        
    }
}
