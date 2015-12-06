//
//  FullScreenPictureDataSourceInitilizeTest.swift
//  instawallpaper
//
//  Created by 佐藤健一朗 on 2015/12/05.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import XCTest
@testable import instawallpaper

class FullScreenPictureDataSourceInitilizeTest: XCTestCase {
    
    let pic = [
        Picture(id: "1132880853098608443_389794652",
            thumbnailURL: NSURL(string:"https://scontent.cdninstagram.com/hphotos-xtp1/t51.2885-15/s640x640/sh0.08/e35/12269994_910126842428939_506438493_n.jpg")!,
            size: CGSizeMake(360, 360),
            imageURL: NSURL(string:"https://scontent.cdninstagram.com/hphotos-xtp1/t51.2885-15/s150x150/e35/12269994_910126842428939_506438493_n.jpg")!)
    ]

    let ARRAY_SIZE = 30
    var pics: [Picture] = []
    
    var contentLoader : ContentLoader = PopularContentLoader()
    
    override func setUp() {
        super.setUp()

        for _ in 1...ARRAY_SIZE {
            pics += pic
        }
        contentLoader.pictureArray = pics

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSelected0_ARRAY_RANGE_3() {
        let dataSource = FullScreenPictureDataSourceTest3(selectedIndex: 0, loader: contentLoader)
        XCTAssertEqual(dataSource.pictureCount(), 4)
        XCTAssertEqual(dataSource.currentInternalIndex, 0)
    }
    
    func testSelected1_ARRAY_RANGE_3() {
        let dataSource = FullScreenPictureDataSourceTest3(selectedIndex: 1, loader: contentLoader)
        XCTAssertEqual(dataSource.pictureCount(), 5)
        XCTAssertEqual(dataSource.currentInternalIndex, 1)
    }
    
    func testSelected2_ARRAY_RANGE_3() {
        let dataSource = FullScreenPictureDataSourceTest3(selectedIndex: 2, loader: contentLoader)
        XCTAssertEqual(dataSource.pictureCount(), 6)
        XCTAssertEqual(dataSource.currentInternalIndex, 2)
    }
    
    func testSelected3_ARRAY_RANGE_3() {
        let dataSource = FullScreenPictureDataSourceTest3(selectedIndex: 3, loader: contentLoader)
        XCTAssertEqual(dataSource.pictureCount(), 7)
        XCTAssertEqual(dataSource.currentInternalIndex, 3)
    }
    
    func testSelected4_ARRAY_RANGE_3() {
        let dataSource = FullScreenPictureDataSourceTest3(selectedIndex: 4, loader: contentLoader)
        XCTAssertEqual(dataSource.pictureCount(), 7)
        XCTAssertEqual(dataSource.currentInternalIndex, 3)
    }
    
    func testSelected5_ARRAY_RANGE_3() {
        let dataSource = FullScreenPictureDataSourceTest3(selectedIndex: 5, loader: contentLoader)
        XCTAssertEqual(dataSource.pictureCount(), 7)
        XCTAssertEqual(dataSource.currentInternalIndex, 3)
    }
    
    func testSelected26_ARRAY_RANGE_3() {
        let dataSource = FullScreenPictureDataSourceTest3(selectedIndex: 26, loader: contentLoader)
        XCTAssertEqual(dataSource.pictureCount(), 7)
        XCTAssertEqual(dataSource.currentInternalIndex, 3)
    }
    
    func testSelected27_ARRAY_RANGE_3() {
        let dataSource = FullScreenPictureDataSourceTest3(selectedIndex: 27, loader: contentLoader)
        XCTAssertEqual(dataSource.pictureCount(), 6)
        XCTAssertEqual(dataSource.currentInternalIndex, 3)
    }
    
    func testSelected28_ARRAY_RANGE_3() {
        let dataSource = FullScreenPictureDataSourceTest3(selectedIndex: 28, loader: contentLoader)
        XCTAssertEqual(dataSource.pictureCount(), 5)
        XCTAssertEqual(dataSource.currentInternalIndex, 3)
    }
    
    func testSelected29_ARRAY_RANGE_3() {
        let dataSource = FullScreenPictureDataSourceTest3(selectedIndex: 29, loader: contentLoader)
        XCTAssertEqual(dataSource.pictureCount(), 4)
        XCTAssertEqual(dataSource.currentInternalIndex, 3)
    }
    
    func testSelected30_ARRAY_RANGE_3() {
        let dataSource = FullScreenPictureDataSourceTest3(selectedIndex: 30, loader: contentLoader)
        XCTAssertEqual(dataSource.pictureCount(), 7)
        XCTAssertEqual(dataSource.currentInternalIndex, 3)
    }
    

}

class FullScreenPictureDataSourceTest3: FullScreenPictureDataSource {
    override var ARRAY_RANGE: Int {
        return 3
    }
}
