//
//  BeverageShopCell.swift
//  MeTime
//
//  Created by hyunchul on 2023/11/17.
//

import Foundation
import UIKit

class BeverageShopCell: UITableViewCell {
    
    var beverage: Beverage? {
        didSet {
            update()
        }
    }
    
    private lazy var priceLabelContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray50
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var priceSubLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray500
        label.text = "캔 500ml 기준 가격"
        return label
    }()
    
    private lazy var priceMainLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .gray800
        label.text = "평균 0원"
        return label
    }()
    
    private lazy var priceDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray400
        let attrString = NSMutableAttributedString(string: "가격 상황이 상이할 수 있어요.\n정확한 정보를 제공하는 미타임이 되도록 노력할게요!")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.3
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        return label
    }()
    
    private lazy var mediumSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray50
        return view
    }()
    
    private lazy var shopMainLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .gray800
        label.text = "판매처"
        return label
    }()
    
    private lazy var shopStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var shopDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray400
        let attrString = NSMutableAttributedString(string: "점포에 따라 재고 상황이 상이할 수 있어요.\n정확한 정보를 제공하는 미타임이 되도록 노력할게요!")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.3
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        return label
    }()
    
    private lazy var lastSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray50
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(priceLabelContainerView)
        priceLabelContainerView.addSubview(priceSubLabel)
        priceLabelContainerView.addSubview(priceMainLabel)
        contentView.addSubview(priceDescriptionLabel)
        contentView.addSubview(mediumSeparator)
        contentView.addSubview(shopMainLabel)
        contentView.addSubview(shopStackView)
        contentView.addSubview(shopDescriptionLabel)
        contentView.addSubview(lastSeparator)
        
        layoutViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private func update() {
        priceMainLabel.text = "평균 \(beverage?.price ?? 0)원"
        makeShop()
    }
    
    private func makeShop() {
        shopStackView.removeAllArrangedSubviews()
        
        let shops = beverage?.distributors ?? []
        for shop in shops {
            let shopLabel = KeywordLabel(
                keyword: shop,
                textColor: .gray900,
                font: .systemFont(ofSize: 14),
                backgroundColor: .gray50
            )
            shopStackView.addArrangedSubview(shopLabel)
        }
    }
    
    private func layoutViews() {
        priceLabelContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(82)
        }
        
        priceSubLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        priceMainLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        priceDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabelContainerView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        mediumSeparator.snp.makeConstraints { make in
            make.top.equalTo(priceDescriptionLabel.snp.bottom).offset(44)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        shopMainLabel.snp.makeConstraints { make in
            make.top.equalTo(mediumSeparator.snp.bottom).offset(44)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        shopStackView.snp.makeConstraints { make in
            make.top.equalTo(shopMainLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }

        shopDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(shopStackView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        lastSeparator.snp.makeConstraints { make in
            make.top.equalTo(shopDescriptionLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(8)
        }
    }
}
