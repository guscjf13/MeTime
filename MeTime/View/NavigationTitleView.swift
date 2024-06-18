//
//  DetailTitleView.swift
//  MeTime
//
//  Created by hyunchul on 2023/11/17.
//

import Foundation
import SnapKit

final class NavigationTitleView: UIView {
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private lazy var backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "LeftArrowBlack")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray800
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray50
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backImageView)
        addSubview(titleLabel)
        addSubview(separator)
        
        backgroundColor = .clear
        
        clipsToBounds = true
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func dismiss() {
        guard let parentViewController = parentViewController() else { return }
        parentViewController.navigationController?.popViewController(animated: true)
    }
    
    func switchAppearance(showTitle: Bool) {
        backgroundColor = showTitle ? .white : .clear
        backImageView.image = showTitle ? UIImage(named: "LeftArrowBlack") : UIImage(named: "LeftArrowWhite")
        titleLabel.isHidden = !showTitle
        separator.isHidden = !showTitle
    }
    
    private func layoutViews() {
        backImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(9)
            make.width.height.equalTo(32)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backImageView)
        }
        
        separator.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
