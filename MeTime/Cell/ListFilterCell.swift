//
//  ListFilterCell.swift
//  MeTime
//
//  Created by hyunchul on 2023/10/27.
//

import Foundation
import UIKit

class ListFilterCell: UICollectionViewCell {
    var title: String?
    var titleColor: UIColor? {
        didSet {
            update()
        }
    }
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 17
        view.layer.borderColor = UIColor.gray100.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "DownArrow")
        return imageView
    }()
    
    private lazy var initImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "InitFilter")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        return imageView
    }()
    
    var isInitFilter: Bool? {
        didSet {
            updateVisibility()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(arrowImageView)
        titleView.addSubview(initImageView)
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func update() {
        guard let title, let titleColor else { return }
        titleLabel.text = title
        titleView.backgroundColor = titleColor
        titleView.layer.borderColor = titleColor == .white
            ? UIColor.gray100.cgColor
            : titleColor.cgColor
    }
    
    private func updateVisibility() {
        guard let isInitFilter else { return }
        
        if isInitFilter {
            initImageView.isHidden = false
            titleLabel.isHidden = true
            arrowImageView.isHidden = true
        } else {
            initImageView.isHidden = true
            titleLabel.isHidden = false
            arrowImageView.isHidden = false
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        initImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        titleView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(34)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(4)
            make.width.height.equalTo(12)
            make.centerY.equalToSuperview()
        }
    }
}
