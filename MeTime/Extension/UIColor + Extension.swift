//
//  UIColor +.swift
//  MeTime
//
//  Created by hyunchul on 2023/09/01.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

extension UIColor {
    class var white: UIColor {
        return UIColor(hexCode: "#FFFFFF")
    }
    class var black: UIColor {
        return UIColor(hexCode: "#090A0D")
    }
    
    class var gray50: UIColor {
        return UIColor(hexCode: "#F7F8F9")
    }
    
    class var gray100: UIColor {
        return UIColor(hexCode: "#E8EBED")
    }
    
    class var gray200: UIColor {
        return UIColor(hexCode: "#C9CDD2")
    }
    
    class var gray400: UIColor {
        return UIColor(hexCode: "#9EA4AA")
    }
    
    class var gray500: UIColor {
        return UIColor(hexCode: "#72787F")
    }
    
    class var gray600: UIColor {
        return UIColor(hexCode: "#454C53")
    }
    
    class var gray800: UIColor {
        return UIColor(hexCode: "#26282B")
    }
    
    class var gray900: UIColor {
        return UIColor(hexCode: "#121319")
    }
    
    class var MTOrange50: UIColor {
        return UIColor(hexCode: "#FFF5EB")
    }
    
    class var MTOrange100: UIColor {
        return UIColor(hexCode: "#FEE6CC")
    }
    
    class var MTOrange200: UIColor {
        return UIColor(hexCode: "#FDC699")
    }
    
    class var MTOrange300: UIColor {
        return UIColor(hexCode: "#FB9E66")
    }
    
    class var MTOrange400: UIColor {
        return UIColor(hexCode: "#F77840")
    }
    
    class var MTOrange500: UIColor {
        return UIColor(hexCode: "#F23B03")
    }
    
    class var MTOrange600: UIColor {
        return UIColor(hexCode: "#D02302")
    }
    
    class var MTOrange700: UIColor {
        return UIColor(hexCode: "#AE1101")
    }
    
    class var MTOrange800: UIColor {
        return UIColor(hexCode: "#8C0300")
    }
    
    class var MTOrange900: UIColor {
        return UIColor(hexCode: "#740006")
    }
    
    class var MTPink100: UIColor {
        return UIColor(hexCode: "#FED3DD")
    }
    
    class var MTPink200: UIColor {
        return UIColor(hexCode: "#FEA7C4")
    }
    
    class var MTPink300: UIColor {
        return UIColor(hexCode: "#FD7BB3")
    }
    
    class var MTPink400: UIColor {
        return UIColor(hexCode: "#FC5AB0")
    }
    
    class var MTPink500: UIColor {
        return UIColor(hexCode: "#FB24AB")
    }
    
    class var MTPink600: UIColor {
        return UIColor(hexCode: "#D71AA4")
    }
    
    class var MTPink700: UIColor {
        return UIColor(hexCode: "#B41298")
    }
    
    class var MTPink800: UIColor {
        return UIColor(hexCode: "#910B87")
    }
    
    class var MTPink900: UIColor {
        return UIColor(hexCode: "#750678")
    }
    
    class var MTYellow: UIColor {
        return UIColor(hexCode: "#FFF026")
    }
    
    class var MTBlue: UIColor {
        return UIColor(hexCode: "#04A2FF")
    }
    
    class var MTGreen: UIColor {
        return UIColor(hexCode: "#0CF47B")
    }
    
    class var MTPurple: UIColor {
        return UIColor(hexCode: "#822FFD")
    }
}

extension UIColor {
    class var HomeTitleTagBg: UIColor {
        return UIColor(hexCode: "#202020")
    }
    
    class var separator: UIColor {
        return UIColor(hexCode: "#EEEEEE")
    }
}
