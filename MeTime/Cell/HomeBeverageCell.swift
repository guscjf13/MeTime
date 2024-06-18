//
//  HomeBeverageCell.swift
//  MeTime
//
//  Created by hyunchul on 2023/09/23.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

protocol HomeBeverageProtocol: AnyObject {
    func like()
}

final class HomeBeverageCell: HomeCell {
    
    weak var delegate: HomeBeverageProtocol?
    
    var beverage: Beverage? {
        didSet {
            update()
        }
    }
    
    private lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray50
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "HomeSelected")
        return imageView
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
    
    private lazy var imageSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = "name"
        label.textColor = .gray500
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "title"
        label.textColor = .gray900
        return label
    }()
    
    private lazy var keywordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var reactionView = ListReactionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .white
        
        addSubview(coverView)
        coverView.addSubview(thumbnailImageView)
        coverView.addSubview(likeImageView)
        coverView.addSubview(imageSeparator)
        coverView.addSubview(nameLabel)
        coverView.addSubview(titleLabel)
        coverView.addSubview(keywordStackView)
        coverView.addSubview(reactionView)
        
        layoutViews()
    }
    
    private func update() {
        guard let beverage else { return }
        
        if let urlString = beverage.thumbnailImageUrl {
            thumbnailImageView.kf.setImage(with: URL(string: urlString))
        }
        titleLabel.text = beverage.name ?? "title"
        makeKeyword()
        reactionView.setReactionCount(
            starCount: beverage.starCount ?? 0,
            commentCount: beverage.reactionCount?.commentCount ?? 0,
            likeCount: beverage.reactionCount?.likeCount ?? 0
        )
    }
    
    private func makeKeyword() {
        keywordStackView.removeAllArrangedSubviews()
        
        let keywords = beverage?.keywords ?? []
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
    
    private func layoutViews() {
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(thumbnailImageView.snp.width)
        }
        
        likeImageView.snp.makeConstraints { make in
            make.trailing.equalTo(thumbnailImageView).inset(20)
            make.bottom.equalTo(thumbnailImageView).inset(12)
            make.width.height.equalTo(24)
        }
        
        imageSeparator.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageSeparator.snp.bottom).offset(16)
            make.height.equalTo(12)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.height.equalTo(14)
            make.leading.trailing.equalTo(nameLabel)
        }
        
        keywordStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        
        reactionView.snp.makeConstraints { make in
            make.top.equalTo(keywordStackView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(nameLabel)
            make.bottom.equalToSuperview().inset(60)
            make.height.equalTo(12)
        }
    }
    
    override func estimatedHeight() -> CGFloat {
        return 366
    }
}


