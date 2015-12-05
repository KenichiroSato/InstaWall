//
//  FullScreenPictureDataSourceText.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/12/05.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import XCTest
@testable import instawallpaper

class FullScreenPictureDataSourceTest: XCTestCase {
    
    let pics = [
        Picture(id: "1132880853098608443_389794652",
            thumbnailURL: NSURL(string:"https://scontent.cdninstagram.com/hphotos-xtp1/t51.2885-15/s640x640/sh0.08/e35/12269994_910126842428939_506438493_n.jpg")!,
            size: CGSizeMake(360, 360),
            imageURL: NSURL(string:"https://scontent.cdninstagram.com/hphotos-xtp1/t51.2885-15/s150x150/e35/12269994_910126842428939_506438493_n.jpg")!),
        Picture(id: "1132880252573021375_1295347780",
            thumbnailURL: NSURL(string:"https://scontent.cdninstagram.com/hphotos-xpf1/t51.2885-15/s640x640/sh0.08/e35/12353857_1067788206594226_1622353414_n.jpg")!,
            size: CGSizeMake(320, 640),
            imageURL: NSURL(string:"https://scontent.cdninstagram.com/hphotos-xpf1/t51.2885-15/s150x150/e35/12353857_1067788206594226_1622353414_n.jpg")!),
        Picture(id: "1132879940408395913_7013409",
            thumbnailURL: NSURL(string:"https://scontent.cdninstagram.com/hphotos-xap1/t51.2885-15/s640x640/sh0.08/e35/12237220_924381380931496_1229231265_n.jpg")!,
            size: CGSizeMake(480, 480),
            imageURL: NSURL(string:"https://scontent.cdninstagram.com/hphotos-xap1/t51.2885-15/s150x150/e35/12237220_924381380931496_1229231265_n.jpg")!),
        ]
    
    var dataSource: FullScreenPictureDataSource!
    
    override func setUp() {
        super.setUp()
        dataSource = FullScreenPictureDataSource(mediaArray: pics)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIndexNinus() {
        XCTAssertNil(dataSource.pictureAtIndex(-1))
    }

    func testIndex0() {
        let pic = dataSource.pictureAtIndex(0)
        XCTAssert(pic != nil)
        XCTAssertEqual(pic?.id, "1132880853098608443_389794652")
    }

    func testIndex1() {
        let pic = dataSource.pictureAtIndex(1)
        XCTAssert(pic != nil)
        XCTAssertEqual(pic?.imageURL, NSURL(string:"https://scontent.cdninstagram.com/hphotos-xpf1/t51.2885-15/s150x150/e35/12353857_1067788206594226_1622353414_n.jpg")!)
    }
    
    func testIndex2() {
        let pic = dataSource.pictureAtIndex(2)
        XCTAssert(pic != nil)
        XCTAssertEqual(pic?.thumbnailURL, NSURL(string:"https://scontent.cdninstagram.com/hphotos-xap1/t51.2885-15/s640x640/sh0.08/e35/12237220_924381380931496_1229231265_n.jpg")!)
    }
    
    func testIndex3() {
        XCTAssertNil(dataSource.pictureAtIndex(3))
    }

}
