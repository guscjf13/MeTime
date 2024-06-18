//
//  BeverageThumbnailCell.swift
//  MeTime
//
//  Created by hyunchul on 2023/11/16.
//

import Foundation
import UIKit
import Kingfisher

class BeverageThumbnailCell: UITableViewCell {
    
    var beverage: Beverage? {
        didSet {
            update()
        }
    }
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray200
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(thumbnailImageView)
        
        thumbnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(366)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private func update() {
        guard let urlString = beverage?.detailImageUrl else { return }
        thumbnailImageView.kf.setImage(with: URL(string: urlString))
    }
}

