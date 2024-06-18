//
//  ListReactionView.swift
//  MeTime
//
//  Created by hyunchul on 2023/09/16.
//

import Foundation
import SnapKit

final class ListReactionView: UIView {
    
    private lazy var starImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "ReactionStar")
        return view
    }()
    
    private lazy var starLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0"
        label.textColor = .gray600
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    
    private lazy var commentImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "ReactionComment")
        return view
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .gray600
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    
    private lazy var likeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "ReactionHeart")
        return view
    }()
    
    private lazy var likeLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .gray600
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(starImageView)
        addSubview(starLabel)
        addSubview(commentImageView)
        addSubview(commentLabel)
        addSubview(likeImageView)
        addSubview(likeLabel)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setReactionCount(starCount: Int, commentCount: Int, likeCount: Int) {
        starLabel.text = String(starCount)
        commentLabel.text = String(commentCount)
        likeLabel.text = String(likeCount)
    }
    
    private func layoutViews() {
        starImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        starLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(starImageView.snp.trailing).offset(4)
        }
        
        commentImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalTo(commentLabel.snp.leading).offset(-4)
            make.width.height.equalTo(12)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(likeImageView.snp.leading).offset(-12)
        }
        
        likeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalTo(likeLabel.snp.leading).offset(-4)
            make.width.height.equalTo(12)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
    }
}

