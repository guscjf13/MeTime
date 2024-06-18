//
//  FilterTextCell.swift
//  MeTime
//
//  Created by hyunchul on 2023/10/28.
//

import Foundation
import UIKit

class FilterTextCell: UITableViewCell {
    
    var title: String?
    
    override var isSelected: Bool {
        didSet {
            update()
        }
    }
    
    private lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Check")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(filterLabel)
        contentView.addSubview(checkImageView)
        
        setNeedsUpdateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private func update() {
        guard let title else { return }
        filterLabel.text = title
        filterLabel.textColor = isSelected ? .MTOrange500 : .black
        checkImageView.isHidden = !isSelected
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        filterLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        checkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
}
