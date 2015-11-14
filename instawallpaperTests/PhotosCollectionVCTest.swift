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

class PhotosCollectionVCTest: XCTestCase {

    var photosVC: PhotosCollectionVC!
    
    override func setUp() {
        super.setUp()

        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        photosVC = storyboard.instantiateViewControllerWithIdentifier("PhotosCollectionVC") as! PhotosCollectionVC
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testnumberOfItems0() {
        var result: Int
        result = photosVC.numberOfItemsTest(0, didHitBottom: false)
        XCTAssertEqual(result, 0)
        result = photosVC.numberOfItemsTest(0, didHitBottom: true)
        XCTAssertEqual(result, 0)
    }
    
    func testnumberOfItems1() {
        var result: Int
        result = photosVC.numberOfItemsTest(1, didHitBottom: false)
        XCTAssertEqual(result, 2)
        result = photosVC.numberOfItemsTest(1, didHitBottom: true)
        XCTAssertEqual(result, 1)
    }
    
    func testnumberOfItems2() {
        var result: Int
        result = photosVC.numberOfItemsTest(2, didHitBottom: false)
        XCTAssertEqual(result, 5)
        result = photosVC.numberOfItemsTest(2, didHitBottom: true)
        XCTAssertEqual(result, 2)
    }

    func testnumberOfItems3() {
        var result: Int
        result = photosVC.numberOfItemsTest(3, didHitBottom: false)
        XCTAssertEqual(result, 5)
        result = photosVC.numberOfItemsTest(3, didHitBottom: true)
        XCTAssertEqual(result, 3)
    }
    
    func testnumberOfItems8() {
        var result: Int
        result = photosVC.numberOfItemsTest(8, didHitBottom: false)
        XCTAssertEqual(result, 11)
        result = photosVC.numberOfItemsTest(8, didHitBottom: true)
        XCTAssertEqual(result, 8)
    }
    
}
