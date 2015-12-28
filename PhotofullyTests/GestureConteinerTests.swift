//
//  GestureConteinerTests.swift
//  Photofully
//
//  Created by Kenichiro Sato on 2015/12/13.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import XCTest
@testable import Photofully

class GestureConteinerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCaseNoAnimations() {
        let conteiner = GestureConteiner()
        XCTAssertEqual(conteiner.minDelay, 0.0)
        XCTAssertEqual(conteiner.totalDuration, 0.0)
    }
    
    func testCaseWithDelay0Animations() {
        let conteiner = GestureConteiner()
        conteiner.animations += [
            GestureView(name: "instructionBack", delay: 0.0, duration: 0.3),
            GestureView(name: "instructionBack", delay: 0.0, duration: 0.5),
            GestureView(name: "instructionBack", delay: 0.3, duration: 1.2),
            GestureView(name: "instructionBack", delay: 0.6, duration: 1.5)
        ]
        XCTAssertEqual(conteiner.minDelay, 0.0)
        XCTAssertEqual(conteiner.totalDuration, 2.1)
    }

    func testCaseWithoutDelay0Animations() {
        let conteiner = GestureConteiner()
        conteiner.animations += [
            GestureView(name: "instructionBack", delay: 0.3, duration: 1.2),
            GestureView(name: "instructionBack", delay: 0.6, duration: 1.5)
        ]
        XCTAssertEqual(conteiner.minDelay, 0.3)
        XCTAssertEqual(conteiner.totalDuration, 1.8)
    }
    
}
