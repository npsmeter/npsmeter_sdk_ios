//
//  UIColor+Ext.swift
//  sdk
//
//  Created by yang chuang on 2021/4/21.
//
import UIKit
 
extension UIColor {
    // Hex String -> UIColor
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
         
        if hexString.hasPrefix("#") {
            if #available(iOS 13.0, *) {
                scanner.currentIndex = hexString.index(after: hexString.startIndex)
            } else {
                // Fallback on earlier versions
            }
        }
         
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
         
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
