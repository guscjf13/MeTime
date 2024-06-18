//
//  BeverageLikeCell.swift
//  MeTime
//
//  Created by hyunchul on 2023/11/17.
//

import Foundation
import UIKit

class BeverageLikeCell: UITableViewCell {
    
    private lazy var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "LikeUnselected")
        return imageView
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .gray800
        label.text = "미타임 모드를 위해 한 잔 보관하세요"
        return label
    }()
    
    private lazy var subLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray400
        label.text = "마셔보고 싶은 술을 미리 저장해 두고 미타임 모드가 필요할 때 한 잔씩 꺼내 즐겨요."
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray50
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(likeImageView)
        contentView.addSubview(mainLabel)
        contentView.addSubview(subLabel)
        contentView.addSubview(separator)
        
        setNeedsUpdateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        likeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(64)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(likeImageView.snp.leading).offset(-44)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(likeImageView.snp.leading).offset(-44)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
            make.bottom.equalToSuperview()
        }
    }
}



