//
//  BeverageTitleCell.swift
//  MeTime
//
//  Created by hyunchul on 2023/11/16.
//

import Foundation
import UIKit

class BeverageTitleCell: UITableViewCell {
    
    var beverage: Beverage? {
        didSet {
            update()
        }
    }
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray500
        label.textAlignment = .center
        label.text = "name"
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .gray900
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "title(국문)"
        return label
    }()
    
    private lazy var titleEnglishLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray400
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "title(영문)"
        return label
    }()
    
    private lazy var keywordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var preferenceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var reactionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(categoryLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleEnglishLabel)
        contentView.addSubview(keywordStackView)
        contentView.addSubview(preferenceStackView)
        contentView.addSubview(reactionStackView)
        
        layoutViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private func update() {
        guard let beverage else { return }
        
        categoryLabel.text = beverage.category?.name
        titleLabel.text = beverage.name
        
        makeKeyword()
        makeStarCount()
        makeReaction()
    }
    
    private func makeKeyword() {
        keywordStackView.removeAllArrangedSubviews()
        
        let keywords = beverage?.keywords ?? []
        for keyword in keywords {
            let keywordLabel = KeywordLabel(
                keyword: keyword,
                textColor: .MTOrange500,
                font: .systemFont(ofSize: 14),
                backgroundColor: .MTOrange100
            )
            keywordStackView.addArrangedSubview(keywordLabel)
        }
    }
    
    private func makeStarCount() {
        preferenceStackView.removeAllArrangedSubviews()
        
        let starCount = beverage?.starCount ?? 0
        
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .MTOrange500
        label.text = String(format: "%.1f", CGFloat(starCount))
        preferenceStackView.addArrangedSubview(label)
        
        for index in 1...5 {
            let imageView = UIImageView()
            imageView.image = index <= starCount ? UIImage(named: "StarSelected") : UIImage(named: "StarUnselected")
            imageView.contentMode = .scaleAspectFill
            imageView.snp.makeConstraints { make in
                make.width.equalTo(20)
            }
            preferenceStackView.addArrangedSubview(imageView)
        }
    }
    
    private func makeReaction() {
        reactionStackView.removeAllArrangedSubviews()
        
        let separator = UIView()
        separator.backgroundColor = .gray100
        separator.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        
        let commentCount = beverage?.reactionCount?.commentCount ?? 0
        let likeCount = beverage?.reactionCount?.likeCount ?? 0
        reactionStackView.addArrangedSubview(makeReactionLabel(text: "\(commentCount)개 댓글"))
        reactionStackView.addArrangedSubview(separator)
        reactionStackView.addArrangedSubview(makeReactionLabel(text: "\(likeCount)개 아카이브"))
    }
    
    private func makeReactionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray400
        return label
    }
    
    private func layoutViews() {
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(14)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        titleEnglishLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        keywordStackView.snp.makeConstraints { make in
            make.top.equalTo(titleEnglishLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        preferenceStackView.snp.makeConstraints { make in
            make.top.equalTo(keywordStackView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        reactionStackView.snp.makeConstraints { make in
            make.top.equalTo(preferenceStackView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
