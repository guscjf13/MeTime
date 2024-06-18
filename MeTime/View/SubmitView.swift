//
//  SubmitView.swift
//  MeTime
//
//  Created by hyunchul on 2023/10/27.
//

import Foundation
import UIKit

protocol SubmitProtocol: AnyObject {
    func initFilter()
    func submit()
}

class SubmitView: UIView {
    
    weak var delegate: SubmitProtocol?
    
    private lazy var initButton: UIButton = {
        let button = UIButton()
        button.setTitle("초기화", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 2
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.layer.borderColor = UIColor.gray100.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(initFilter), for: .touchUpInside)
        return button
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("적용하기", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 2
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(submit), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(initButton)
        addSubview(submitButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func initFilter() {
        delegate?.initFilter()
    }
    
    @objc
    private func submit() {
        delegate?.submit()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        let padding: CGFloat = 16
        let spacing: CGFloat = 10
        let side = (UIScreen.main.bounds.width - 2 * padding - spacing) / CGFloat(3)
        
        initButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(padding)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(side)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(padding)
            make.leading.equalTo(initButton.snp.trailing).offset(spacing)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
