//
//  BeverageEvaluationCell.swift
//  MeTime
//
//  Created by hyunchul on 2023/11/17.
//

import Foundation
import UIKit

class BeverageEvaluationCell: UITableViewCell {
    
    private lazy var evaluationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Evaluation")
        return imageView
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .gray800
        label.text = "미타임 모드를 즐기셨나요?"
        return label
    }()
    
    private lazy var subLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray400
        label.text = "이 주류로 미타임을 얼마나 잘 즐겼는지 평가해 주세요."
        return label
    }()
    
    private lazy var starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var lastSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray50
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(evaluationImageView)
        contentView.addSubview(mainLabel)
        contentView.addSubview(subLabel)
        contentView.addSubview(starStackView)
        contentView.addSubview(lastSeparator)
        
        makeStar()
        
        setNeedsUpdateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private func makeStar() {
        starStackView.removeAllArrangedSubviews()
        
        for index in 1...5 {
            let imageView = UIImageView()
            imageView.image = index <= 4 ? UIImage(named: "StarSelected") : UIImage(named: "StarUnselected")
            imageView.contentMode = .scaleAspectFill
            imageView.snp.makeConstraints { make in
                make.width.equalTo(36)
            }
            starStackView.addArrangedSubview(imageView)
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        evaluationImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(44)
            make.centerX.equalToSuperview()
            make.height.equalTo(28)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(evaluationImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        starStackView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(36)
        }
        
        lastSeparator.snp.makeConstraints { make in
            make.top.equalTo(starStackView.snp.bottom).offset(44)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
            make.bottom.equalToSuperview()
        }
    }
}


