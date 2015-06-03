//
//  ImageUtil.swift
//  instawallpaper
//
//  Created by 佐藤健一朗 on 2015/05/31.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

public class ImageUtil {
    
    static private let COLOR_LIKENESS_THRESHOLD: CGFloat = 20
    
    static private let DEFAULT_COLOR = UIColor.whiteColor()
    
    public enum Position {
        case TOP, BOTTOM
    }
    
    static func mostFrequentColor(image:UIImage, position:Position) -> UIColor {
        if let colorList: [CountableColor] = getColorCandidates(image, position: position),
               mostFrequent = (colorList.sorted{$0.count > $1.count}).first {
                return UIColor(red: mostFrequent.red, green: mostFrequent.green,
                    blue: mostFrequent.blue, alpha: 255.0)
        }
        return ImageUtil.DEFAULT_COLOR
    }
    
    static private func getColorCandidates(image: UIImage, position: Position) -> [CountableColor]? {
        switch (position) {
        case .TOP:
            return getXAxisColorCandidates(0.0, image: image);
        case .BOTTOM:
            return getXAxisColorCandidates(image.size.height - 1, image: image)
        default:
            return nil
        }
    }
    
    private static func  getXAxisColorCandidates(y: CGFloat, image: UIImage) -> [CountableColor] {
        var colorList: [CountableColor] = []
        let firstColor: CountableColor = CountableColor(color: pixelColor(image, pos: CGPoint(x: 0, y: y)))
        colorList.append(firstColor)
        searchFrequentColorLoop: for var x:CGFloat = 1; x < image.size.width; x++ {
            let candidate: CountableColor = CountableColor(color: pixelColor(image, pos: CGPoint(x: x, y: y)))
            for color in colorList {
                if (getColorDiff(color, c2: candidate) < ImageUtil.COLOR_LIKENESS_THRESHOLD) {
                    color.updateColor(candidate)
                    break searchFrequentColorLoop
                }
            }
            colorList.append(candidate)
        }
        return colorList
    }
    
    private static func pixelColor(image: UIImage, pos: CGPoint) -> UIColor {
        var pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage))
        var data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        var pixelInfo: Int = ((Int(image.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        var r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        var g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        var b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        var a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    private class CountableColor {
        var red : CGFloat
        var green : CGFloat
        var blue : CGFloat
        var count : UInt
        
        init(color : UIColor) {
            let ciColor = CIColor(color: color)!
            red = ciColor.red()
            green = ciColor.green()
            blue = ciColor.blue()
            count = 1
        }
        
        func updateColor(color : CountableColor) {
            red = (red + color.red) / 2
            green = (green + color.green) / 2
            blue = (blue + color.blue) / 2
            count++
        }
    }
    
     static private func getColorDiff(c1:CountableColor , c2:CountableColor) -> CGFloat {
        var diff : CGFloat = 0
        diff += abs(c1.red - c2.red)
        diff += abs(c1.green - c2.green)
        diff += abs(c1.blue - c2.blue)
        return diff;
    }
    
    
}