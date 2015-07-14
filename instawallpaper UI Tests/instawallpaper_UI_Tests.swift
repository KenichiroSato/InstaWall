//
//  instawallpaper_UI_Tests.swift
//  instawallpaper UI Tests
//
//  Created by 佐藤健一朗 on 2015/06/20.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation
import XCTest
@testable import instawallpaper

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
    
    func testSearch() {
        
        let app = XCUIApplication()
        let searchKeywordTextField = app.navigationBars["instawallpaper.PhotosCollectionVC"].textFields["Search keyword"]
        searchKeywordTextField.tap()
        searchKeywordTextField.typeText("cat")
        app.typeText("\r")
        
    }
    
    func testSelectPhoto() {
        
        let app = XCUIApplication()
//        app.collectionViews.activityIndicators["In progress"].tap()
            app.collectionViews.childrenMatchingType(.Cell).elementBoundByIndex(0).descendantsMatchingType(.Unknown).childrenMatchingType(.Image).elementBoundByIndex(0).tap()
        
        let textField = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Unknown).element.childrenMatchingType(.Unknown).element.childrenMatchingType(.Unknown).element.childrenMatchingType(.Unknown).element.childrenMatchingType(.Unknown).elementBoundByIndex(2).childrenMatchingType(.TextField).element
        textField.tap()
        textField.typeText("cat\r")
        app.buttons["GO"].tap()
        app.alerts["Please input appropriate URL"].collectionViews.buttons["OK"].tap()
        app.buttons["Back"].tap()
        
    }
    
    func testSaveImage() {
        
        let app = XCUIApplication()
        app.collectionViews.childrenMatchingType(.Cell).elementBoundByIndex(0).descendantsMatchingType(.Unknown).childrenMatchingType(.Image).elementBoundByIndex(0).tap()
        
        let image = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Unknown).element.childrenMatchingType(.Unknown).element.childrenMatchingType(.Unknown).element.childrenMatchingType(.Unknown).element.childrenMatchingType(.Unknown).elementBoundByIndex(1).childrenMatchingType(.Image).element
        image.tap()
        
        let sheetsQuery = app.sheets
        sheetsQuery.buttons["Cancel"].tap()
        image.tap()
        sheetsQuery.collectionViews.buttons["Save"].tap()
        app.buttons["Back"].tap()
        
    }
    
}
