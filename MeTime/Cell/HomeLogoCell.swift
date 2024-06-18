//
//  HomeLogoCell.swift
//  MeTime
//
//  Created by hyunchul on 2023/09/01.
//

import Foundation
import UIKit
import SnapKit

final class HomeLogoCell: HomeCell {
    
    private lazy var logoImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Logo")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .gray900
        
        addSubview(logoImageView)
        layoutViews()
    }
    
    private func layoutViews() {
        logoImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
    }
    
    override func estimatedHeight() -> CGFloat {
        return 114
    }
}
