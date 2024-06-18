//
//  UIViewController + Extension.swift
//  MeTime
//
//  Created by hyunchul on 2023/10/27.
//

import Foundation
import UIKit

extension UIView {
    func parentViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.parentViewController()
        } else {
            return nil
        }
    }
}


extension UIViewController {
    func changeToPriceString(priceRange: PriceRange) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        guard let minimumString = numberFormatter.string(from: NSNumber(value: priceRange.minimum)),
              let maximumString = numberFormatter.string(from: NSNumber(value: priceRange.maximum)) else {
            return nil
        }
        
        return "\(minimumString)원 ~ \(maximumString)원"
    }
}
