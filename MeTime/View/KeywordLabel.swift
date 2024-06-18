//
//  File.swift
//  MeTime
//
//  Created by hyunchul on 2023/11/17.
//

import Foundation
import UIKit

class KeywordLabel: UILabel {
    
    var keyword: String
    var sidePadding: CGFloat
    
    override var intrinsicContentSize: CGSize {
        let textWidth = NSString(string: keyword).size(withAttributes: [NSAttributedString.Key.font : font ?? .systemFont(ofSize: 14)]).width
        let width = sidePadding * 2 + textWidth
        let size = CGSize(width: width, height: 100)
        
        return size
    }
    
    init(keyword: String, textColor: UIColor, font: UIFont, sidePadding: CGFloat = 12, backgroundColor: UIColor) {
        self.keyword = keyword
        self.sidePadding = sidePadding
        
        super.init(frame: .zero)
        
        self.text = keyword
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.font = font
        self.textAlignment = .center
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
