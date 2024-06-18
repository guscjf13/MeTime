//
//  ListBeverageCell.swift
//  MeTime
//
//  Created by hyunchul on 2023/09/16.
//

import Foundation
import UIKit
import SnapKit

protocol ListBeverageProtocol: AnyObject {
    func like()
}

final class ListBeverageCell: UITableViewCell {
    
    weak var delegate: ListBeverageProtocol?
    
    var beverage: Beverage? {
        didSet {
            update()
        }
    }
    
    var hasTopInset: Bool = true {
        didSet {
            updateTopInset()
        }
    }
    
    private lazy var thumbnailImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray50
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = "name"
        label.textColor = .gray500
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "title"
        label.textColor = .gray900
        return label
    }()
    
    private lazy var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Unlike")
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(like))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    
    private lazy var keywordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var reactionView = ListReactionView()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private func setUp() {
        selectionStyle = .none
        backgroundColor = .white
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(likeImageView)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(keywordStackView)
        contentView.addSubview(reactionView)
        contentView.addSubview(separator)
        
        layoutViews()
    }
    
    private func makeKeyword(keywords: [String]) {
        keywordStackView.removeAllArrangedSubviews()
        
        for keyword in keywords {
            let keywordLabel = KeywordLabel(
                keyword: keyword,
                textColor: .MTOrange500,
                font: .systemFont(ofSize: 12),
                sidePadding: 8,
                backgroundColor: .MTOrange100
            )
            keywordStackView.addArrangedSubview(keywordLabel)
        }
    }
    
    @objc
    private func like() {
        delegate?.like()
    }
    
    private func updateTopInset() {
        thumbnailImageView.snp.updateConstraints { make in
            let inset = hasTopInset ? 12 : 0
            make.top.equalToSuperview().inset(inset)
        }
    }
    
    private func update() {
        guard let beverage else { return }
        
        if let urlString = beverage.thumbnailImageUrl {
            thumbnailImageView.kf.setImage(with: URL(string: urlString))
        }
        categoryLabel.text = beverage.category?.name ?? "종류"
        nameLabel.text = beverage.name
        makeKeyword(keywords: beverage.keywords ?? [])
        reactionView.setReactionCount(
            starCount: beverage.starCount ?? 0,
            commentCount: beverage.reactionCount?.commentCount ?? 0,
            likeCount: beverage.reactionCount?.likeCount ?? 0
        )
    }
    
    private func layoutViews() {
        thumbnailImageView.snp.makeConstraints { make in
            let side = UIScreen.main.bounds.width * (CGFloat(1) / CGFloat(3))
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview()
            make.bottom.equalTo(separator)
            make.width.height.equalTo(side)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView).inset(8)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(categoryLabel)
        }
        
        likeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(20)
        }
        
        keywordStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.leading.equalTo(categoryLabel)
            make.height.equalTo(20)
        }
        
        reactionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(categoryLabel)
            make.bottom.equalTo(separator).offset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(12)
        }
        
        separator.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

