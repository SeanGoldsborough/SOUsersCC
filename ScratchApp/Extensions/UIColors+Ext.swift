//
//  UIColors+Ext.swift
//  ScratchApp
//
//  Created by Sean Goldsborough on 1/6/20.
//  Copyright © 2020 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static let themeColor = UIColor(red: 210.0/255.0, green: 105.0/255.0, blue: 130.0/255.0, alpha: 1.0)
    static let goldBadgeColor = UIColor(hex: "#ffc600")
    static let silverBadgeColor = UIColor(hex: "#acb0b4")
    static let bronzeBadgeColor = UIColor(hex: "#cc9c78")
}

extension UIColor {
    convenience init(hex: String) {
        
        var rgbValue:UInt64 = 0
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }

        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
