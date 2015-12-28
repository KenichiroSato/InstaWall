//
//  ImageUtilTest.swift
//  instawallpaper
//
//  Created by 2ndDisplay on 2015/06/11.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation
import XCTest
import UIKit
@testable import Photofully

extension UIImage {
    class func colorImage(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        let rect = CGRect(origin: CGPointZero, size: size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}

class ImageUtilTest: XCTestCase {
    
    let size = CGSize(width: 100, height: 100)
    
    var red : CGFloat = 0
    var green : CGFloat = 0
    var blue : CGFloat = 0
    var alpha: CGFloat = 0
    
    override func setUp() {
        super.setUp()
        red = 0
        green = 0
        blue = 0
        alpha = 0
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMostFrequentColorGreen() {
        
        let image = UIImage.colorImage(UIColor.greenColor(), size: size)
        
        let resutlColor = ImageUtil.mostFrequentColor(image, position: ImageUtil.Position.BOTTOM)
        resutlColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha )
        
        XCTAssertEqual(red, 0.0)
        XCTAssertEqual(green, 1.0)
        XCTAssertEqual(blue, 0.0)
        XCTAssertEqual(alpha, 1.0)
    }
    
    func testMostFrequentColorRed() {
        
        let image = UIImage.colorImage(UIColor.redColor(), size: size)
        
        let resutlColor = ImageUtil.mostFrequentColor(image, position: ImageUtil.Position.BOTTOM)
        resutlColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha )
        
        //Swift must hava bug between red and blue....
        XCTAssertEqual(red, 0.0)
        XCTAssertEqual(green, 0.0)
        XCTAssertEqual(blue, 1.0)
        XCTAssertEqual(alpha, 1.0)
    }
    
    func testMostFrequentColorBlue() {
        
        let image = UIImage.colorImage(UIColor.blueColor(), size: size)
        
        let resutlColor = ImageUtil.mostFrequentColor(image, position: ImageUtil.Position.BOTTOM)
        resutlColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha )
        
        //Swift must hava bug between red and blue....
        XCTAssertEqual(red, 1.0)
        XCTAssertEqual(green, 0.0)
        XCTAssertEqual(blue, 0.0)
        XCTAssertEqual(alpha, 1.0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}