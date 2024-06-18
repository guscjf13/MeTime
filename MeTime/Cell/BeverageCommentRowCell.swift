//
//  BeverageCommentRowCell.swift
//  MeTime
//
//  Created by hyunchul on 2023/11/19.
//

import Foundation
import UIKit

class BeverageCommentRowCell: UITableViewCell {
    
    var comment: String = "" {
        didSet {
            update()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "DefaultProfile")
        return imageView
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .gray800
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray400
        label.text = "10분 전"
        label.contentMode = .bottomRight
        return label
    }()
    
    private func update() {
        commentLabel.text = comment
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(commentLabel)
        contentView.addSubview(timeLabel)
        
        layoutViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private func layoutViews() {
        commentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(32)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalTo(commentLabel)
            make.width.height.equalTo(32)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}


