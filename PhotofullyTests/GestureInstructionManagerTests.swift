//
//  GestureInstructionManager.swift
//  instawallpaper
//
//  Created by 2ndDisplay on 2015/12/10.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import XCTest
@testable import Photofully

class GestureInstructionManagerTests: XCTestCase {
    
    let gestureManager = GestureInstructionManagerTest()
    
    override func setUp() {
        super.setUp()
        gestureManager.resetAllFlags()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNormalScenario() {
        let gesture1 = gestureManager.gestureToBeShown()
        XCTAssertTrue(gesture1 is DownToUp)
        gestureManager.doneDownToUp()
        
        let gesture2 = gestureManager.gestureToBeShown()
        XCTAssertTrue(gesture2 is LeftToRight)
        gestureManager.doneLeftToRight()
        
        let gesture3 = gestureManager.gestureToBeShown()
        XCTAssertTrue(gesture3 is RightToLeft)
        gestureManager.doneRightToLeft()
        
        XCTAssertNil(gestureManager.gestureToBeShown())
    }
    
    func testDidDownToUp() {
        
        gestureManager.doneDownToUp()
        
        let gesture1 = gestureManager.gestureToBeShown()
        XCTAssertTrue(gesture1 is LeftToRight)
        gestureManager.doneLeftToRight()
        
        let gesture2 = gestureManager.gestureToBeShown()
        XCTAssertTrue(gesture2 is RightToLeft)
        gestureManager.doneRightToLeft()
        
        XCTAssertNil(gestureManager.gestureToBeShown())
    }

    
    func testDidLeftToRight() {
        
        gestureManager.doneLeftToRight()
        
        let gesture1 = gestureManager.gestureToBeShown()
        XCTAssertTrue(gesture1 is DownToUp)
        gestureManager.doneDownToUp()
        
        let gesture2 = gestureManager.gestureToBeShown()
        XCTAssertTrue(gesture2 is RightToLeft)
        gestureManager.doneRightToLeft()
        
        XCTAssertNil(gestureManager.gestureToBeShown())
    }
    
    func testDidRightToLeft() {
        
        gestureManager.doneRightToLeft()
        
        let gesture1 = gestureManager.gestureToBeShown()
        XCTAssertTrue(gesture1 is DownToUp)
        gestureManager.doneDownToUp()
        
        let gesture2 = gestureManager.gestureToBeShown()
        XCTAssertTrue(gesture2 is LeftToRight)
        gestureManager.doneLeftToRight()
        
        XCTAssertNil(gestureManager.gestureToBeShown())
    }
    
    func testDid_DownToUp_RightToLeft() {
        
        gestureManager.doneDownToUp()
        gestureManager.doneRightToLeft()
        
        let gesture1 = gestureManager.gestureToBeShown()
        XCTAssertTrue(gesture1 is LeftToRight)
        gestureManager.doneLeftToRight()
        
        XCTAssertNil(gestureManager.gestureToBeShown())
    }
    
    func testDid_DownToUp_LeftToRight() {
        
        gestureManager.doneDownToUp()
        gestureManager.doneLeftToRight()
        
        let gesture1 = gestureManager.gestureToBeShown()
        XCTAssertTrue(gesture1 is RightToLeft)
        gestureManager.doneRightToLeft()
        
        XCTAssertNil(gestureManager.gestureToBeShown())
    }
    
    func testDid_RightToLeft_LeftToRight() {
        
        gestureManager.doneRightToLeft()
        gestureManager.doneLeftToRight()
        
        let gesture1 = gestureManager.gestureToBeShown()
        XCTAssertTrue(gesture1 is DownToUp)
        gestureManager.doneDownToUp()
        
        XCTAssertNil(gestureManager.gestureToBeShown())
    }
    
    func testDid_RightToLeft_LeftToRight_DownToUp() {
        
        gestureManager.doneRightToLeft()
        gestureManager.doneLeftToRight()
        gestureManager.doneDownToUp()
        
        XCTAssertNil(gestureManager.gestureToBeShown())
    }
    
    
}

class GestureInstructionManagerTest: GestureInstructionManager {
    
    func resetAllFlags() {
        gestures.forEach({$0.resetFlag()})
    }
    
}