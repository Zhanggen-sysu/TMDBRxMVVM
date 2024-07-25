//
//  CommonExtension.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/18.
//

import Foundation
import UIKit
import Localize_Swift

extension StaticString {
    
    func localized() -> String {
        return description.localized()
    }
}

// 用https://www.codeconvert.ai/objective_c-to-swift-converter转的
extension UIImage {
    
    func magicColor() -> UIColor? {
        return UIImage.getMagicColorByCompressedImg(image: self)
    }
    
    static func compressImage(image: UIImage, maxWidth: CGFloat) -> UIImage {
        let width = image.cgImage?.width ?? 0
        if width < Int(maxWidth) {
            return image
        }
        let sizeHeight = maxWidth * image.size.height / image.size.width
        let scaleSize = CGSize(width: maxWidth, height: sizeHeight)
        UIGraphicsBeginImageContext(scaleSize)
        image.draw(in: CGRect(origin: .zero, size: scaleSize))
        let scaleImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
        UIGraphicsEndImageContext()
        return scaleImage
    }
    
    static func getRawDataFromImage(image: UIImage, total: inout Int) -> UnsafeMutablePointer<UInt8>? {
        guard let imageRef = image.cgImage else { return nil }
        let width = imageRef.width
        let height = imageRef.height
        total = width * height
        let bytesPerPixel = 4
        let rawData = UnsafeMutablePointer<UInt8>.allocate(capacity: total * bytesPerPixel)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitsPerComponent = 8
        let bytesPerRow = bytesPerPixel * width
        guard let context = CGContext(data: rawData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue) else {
            rawData.deallocate()
            return nil
        }
        context.draw(imageRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        return rawData
    }
    
    static func getMagicColorByCompressedImg(image: UIImage) -> UIColor? {
        let maxWidth: CGFloat = 64
        let scaleImage = UIImage.compressImage(image: image, maxWidth: maxWidth)
        
        var total: Int = 0
        guard let rawData = UIImage.getRawDataFromImage(image: scaleImage, total: &total) else { return nil }
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let bytesPerPixel = 4
        for i in 0..<total {
            let byteIndex = i * bytesPerPixel
            red += CGFloat(rawData[byteIndex]) / 255.0
            green += CGFloat(rawData[byteIndex + 1]) / 255.0
            blue += CGFloat(rawData[byteIndex + 2]) / 255.0
            alpha += CGFloat(rawData[byteIndex + 3]) / 255.0
        }
        rawData.deallocate()
        
        if total > 0 {
            red /= CGFloat(total)
            green /= CGFloat(total)
            blue /= CGFloat(total)
            alpha /= CGFloat(total)
        }
        
        var outputColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        var colorHue: CGFloat = 0
        var colorSat: CGFloat = 0
        var colorBright: CGFloat = 0
        var colorAlpha: CGFloat = 0
        outputColor.getHue(&colorHue, saturation: &colorSat, brightness: &colorBright, alpha: &colorAlpha)
        
        if colorSat < 0.618 {
            let factor = 0.618
            colorSat = colorSat + (factor - colorSat) * (1 - factor)
        }
        
        if colorBright > 0.618 {
            colorBright *= 0.618
        }
        
        outputColor = UIColor(hue: colorHue, saturation: colorSat, brightness: colorBright, alpha: colorAlpha)
        return outputColor
    }
}


extension UIColor {
    // 颜色色值加深/变浅
    func deeperColor(with degree: CGFloat) -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: nil)
        r = max(min(r*255+degree, 255), 0)
        g = max(min(g*255+degree, 255), 0)
        b = max(min(b*255+degree, 255), 0)
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
