//
//  File.swift
//  MeTime
//
//  Created by hyunchul on 2023/09/18.
//

import Foundation
import SnapKit

enum Title {
    case list
    case favorite
}

final class MainTitleView: UIView {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .gray900
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    var type: Title
    
    init(type: Title) {
        self.type = type
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubview(imageView)
        addSubview(label)
        
        clipsToBounds = true
        
        update()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func update() {
        switch type {
        case .list:
            imageView.image = UIImage(named: "ListTitle")
            label.text = "drinks for me"
        case .favorite:
            imageView.image = UIImage(named: "FavoriteTitle")
            label.text = "me time mode"
        }
    }
    
    private func layoutViews() {
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }

        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(8)
        }
    }
}

