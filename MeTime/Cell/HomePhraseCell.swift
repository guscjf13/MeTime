//
//  HomePhraseCell.swift
//  MeTime
//
//  Created by hyunchul on 2023/09/05.
//

import Foundation
import UIKit
import SnapKit

final class HomePhraseCell: HomeCell {
    
    private lazy var phraseLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .gray900
        label.textAlignment = .right
        
        let attributedString = NSMutableAttributedString(string: "\"set you on\nme time mode\"")
        attributedString.addAttribute(
            NSAttributedString.Key.kern,
            value: 3,
            range: NSRange(
                location: 0,
                length: attributedString.length)
        )
        label.attributedText = attributedString
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .white
        
        addSubview(phraseLabel)
        
        layoutViews()
    }
    
    private func layoutViews() {
        phraseLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(90)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    override func estimatedHeight() -> CGFloat {
        return 170
    }
}
