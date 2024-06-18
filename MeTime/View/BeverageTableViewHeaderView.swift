//
//  BeverageTableViewHeaderView.swift
//  MeTime
//
//  Created by hyunchul on 2023/11/18.
//

import Foundation
import UIKit

protocol ListTableViewHeaderProtocol: AnyObject {
    func changeOrderType()
}

class BeverageTableViewHeaderView: UIView {
    
    weak var delegate: ListTableViewHeaderProtocol?
    
    enum HeaderType {
        case separator
        case none
    }
    
    var totalNum: Int = 0
    var orderType: OrderType = .recommend {
        didSet {
            update()
        }
    }
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray500
        return label
    }()
    
    private lazy var orderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeOrderType))
        stackView.addGestureRecognizer(tapGestureRecognizer)
        return stackView
    }()
    
    private lazy var orderTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray500
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "DownArrow")
        imageView.snp.makeConstraints { make in
            make.width.equalTo(12)
        }
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(countLabel)
        addSubview(orderStackView)
        
        orderStackView.addArrangedSubview(orderTypeLabel)
        orderStackView.addArrangedSubview(arrowImageView)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func update() {
        countLabel.text = "총 \(totalNum)개"
        orderTypeLabel.text = orderType.description
        
        orderStackView.isHidden = orderType == .none
    }
    
    @objc
    private func changeOrderType() {
        delegate?.changeOrderType()
    }
    
    private func layoutViews() {
        countLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        orderStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(12)
        }
    }
}
