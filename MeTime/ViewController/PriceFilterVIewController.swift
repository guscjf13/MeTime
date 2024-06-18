//
//  PriceFilterViewController.swift
//  MeTime
//
//  Created by hyunchul on 2023/10/25.
//

import Foundation
import UIKit

class PriceFilterViewController: FilterViewController {
    
    private let priceLabelTopMargin: CGFloat = 32
    private let priceLabelHeight: CGFloat = 20
    private let priceViewTopMargin: CGFloat = 32
    private let priceViewHeight: CGFloat = 50
    private let priceViewBottomMargin: CGFloat = 40
    
    override var contentHeight: CGFloat {
        return priceLabelTopMargin + priceLabelHeight + priceViewTopMargin + priceViewHeight + priceViewBottomMargin
    }
    
    var priceRange = PriceRange(minimum: 0, maximum: 50000)
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .MTOrange500
        label.text = changeToPriceString(priceRange: priceRange)
        return label
    }()
    
    private lazy var priceFilterView: PriceFilterView = {
        let priceFilterView = PriceFilterView()
        priceFilterView.delegate = self
        priceFilterView.priceRange = priceRange
        return priceFilterView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "가격대"
        
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceFilterView)
        
        layoutViews()
    }
    
    private func setPriceLabel() {
        guard let description = changeToPriceString(priceRange: priceRange) else { return }
        priceLabel.text = description
    }
    
    private func layoutViews() {
        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(priceLabelTopMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(priceLabelHeight)
        }
        
        priceFilterView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(priceViewTopMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(priceViewHeight)
        }
    }
}

extension PriceFilterViewController: PriceFilterProtocol {
    func changePrice(priceRange: PriceRange) {
        self.priceRange = priceRange
        setPriceLabel()
    }
}

extension PriceFilterViewController {
    override func initFilter() {
        priceFilterView.initFilter()
    }
    
    override func submit() {
        delegate?.changePrice(priceRange: priceRange)
        dismissView()
    }
}
