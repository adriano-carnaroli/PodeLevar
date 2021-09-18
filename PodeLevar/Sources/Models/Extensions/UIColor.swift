//
//  UIColor.swift
//
//  Created by Adriano Carnaroli.
//  Copyright © 2021 Adriano Carnaroli. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hexString: String, opacity: CGFloat = 1.0) {
        let hexint = Int(UIColor.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: opacity)
    }

    private class func hexToColor(hexString: String) -> Self {
        // Convert hex string to an integer
        let hexint = Int(UIColor.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        return self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    private class func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }

    public convenience init(redValue:CGFloat, greenValue:CGFloat, blueValue:CGFloat, alpha:CGFloat = 1.0) {
        self.init(red: (redValue/255.0), green: (greenValue/255.0), blue: (blueValue/255.0), alpha: alpha)
    }

}
