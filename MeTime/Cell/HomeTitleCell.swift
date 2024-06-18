//
//  HomeTitleCell.swift
//  MeTime
//
//  Created by hyunchul on 2023/09/02.
//

import Foundation
import UIKit
import SnapKit

final class HomeTitleCell: HomeCell {
    
    private let tagLabel = TagLabel()
    
    var bannerPage: Int = 0 {
        didSet {
            update()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "set you on me time mode"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray200
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
        backgroundColor = .gray900
        
        addSubview(tagLabel)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        update()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(changeBanner),
            name: .bannerChanged,
            object: nil
        )
        
        layoutViews()
    }
    
    @objc
    private func changeBanner(notification: Notification) {
        guard let bannerPage = notification.userInfo?["bannerPage"] as? Int else { return }
        self.bannerPage = bannerPage
    }
    
    private func update() {
        tagLabel.text = "#tag \(bannerPage)"
        titleLabel.text = "title \(bannerPage)"
        descriptionLabel.text = "set you on me time mode \(bannerPage)"
    }
    
    private func layoutViews() {
        tagLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).offset(12)
            make.leading.equalTo(tagLabel)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(tagLabel)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    override func estimatedHeight() -> CGFloat {
        return 130
    }
}

extension HomeTitleCell {
    private final class TagLabel: UILabel {
        private let topInset: CGFloat = 4.0
        private let bottomInset: CGFloat = 4.0
        private let leftInset: CGFloat = 8.0
        private let rightInset: CGFloat = 8.0
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            numberOfLines = 0
            font = .systemFont(ofSize: 12)
            textColor = .gray400
            backgroundColor = .HomeTitleTagBg
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawText(in: rect.inset(by: insets))
        }
         override var intrinsicContentSize: CGSize {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
        }
    }
}
