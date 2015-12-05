//
//  PhotosCollectionVC.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/11/14.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import XCTest
import InstagramKit
@testable import instawallpaper

class GridPitureDataSourceTest: XCTestCase {

    var dataSource: GridPictureDataSource!
    
    override func setUp() {
        super.setUp()

        dataSource = GridPictureDataSource(contentLoader: FeedContentLoader())
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testnumberOfItems0() {
        var result: Int
        result = dataSource.numberOfItems(0, didHitBottom: false)
        XCTAssertEqual(result, 0)
        result = dataSource.numberOfItems(0, didHitBottom: true)
        XCTAssertEqual(result, 0)
    }
    
    func testnumberOfItems1() {
        var result: Int
        result = dataSource.numberOfItems(1, didHitBottom: false)
        XCTAssertEqual(result, 2)
        result = dataSource.numberOfItems(1, didHitBottom: true)
        XCTAssertEqual(result, 1)
    }
    
    func testnumberOfItems2() {
        var result: Int
        result = dataSource.numberOfItems(2, didHitBottom: false)
        XCTAssertEqual(result, 5)
        result = dataSource.numberOfItems(2, didHitBottom: true)
        XCTAssertEqual(result, 2)
    }

    func testnumberOfItems3() {
        var result: Int
        result = dataSource.numberOfItems(3, didHitBottom: false)
        XCTAssertEqual(result, 5)
        result = dataSource.numberOfItems(3, didHitBottom: true)
        XCTAssertEqual(result, 3)
    }
    
    func testnumberOfItems8() {
        var result: Int
        result = dataSource.numberOfItems(8, didHitBottom: false)
        XCTAssertEqual(result, 11)
        result = dataSource.numberOfItems(8, didHitBottom: true)
        XCTAssertEqual(result, 8)
    }
    
}
