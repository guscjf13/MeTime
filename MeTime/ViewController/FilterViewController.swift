//
//  FilterViewController.swift
//  MeTime
//
//  Created by hyunchul on 2023/10/22.
//

import Foundation
import UIKit

protocol FilterProtocol: AnyObject {
    func changePrice(priceRange: PriceRange)
    func changeCapacities(capacities: [Capacity])
    func changeFlavor(flavors: Flavors)
}

@objc
protocol SubmitProtocol: AnyObject {
    @objc func submit()
    @objc func initFilter()
}

class FilterViewController: UIViewController {
    
    weak var delegate: FilterProtocol?
    
    override var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        return view
    }()
    
    var bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 27
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "#EAEEF2")
        view.layer.cornerRadius = 2
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var contentView = UIView()
    
    var contentHeight: CGFloat {
        return 0
    }
    
    private lazy var submitStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.addArrangedSubview(initButton)
        stackView.addArrangedSubview(submitButton)
        stackView.isHidden = !hasSubmitView
        return stackView
    }()
    
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
        button.snp.makeConstraints { make in
            make.width.equalTo(110)
        }
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
    
    private let indicatorViewHeight: CGFloat = 24
    private let titleLabelHeight: CGFloat = 38
    private let submitViewHeight: CGFloat = 80
    
    private var totalHeight: CGFloat {
        return indicatorViewHeight + titleLabelHeight + contentHeight + (hasSubmitView ? submitViewHeight : 0) + view.safeAreaInsets.bottom
    }
    
    var hasSubmitView: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(dimmedView)
        view.addSubview(bottomSheetView)
        
        bottomSheetView.addSubview(indicatorView)
        bottomSheetView.addSubview(titleLabel)
        bottomSheetView.addSubview(contentView)
        bottomSheetView.addSubview(submitStackView)
        layoutViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
    
    @objc
    func dismissView() {
        self.dismiss(animated: true)
    }
    
    private func showBottomSheet() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self else { return }
            
            self.dimmedView.alpha = 0.5
            self.bottomSheetView.snp.updateConstraints() { make in
                make.height.equalTo(self.totalHeight)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func layoutViews() {
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(4)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(indicatorView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(titleLabelHeight)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(contentHeight)
        }

        submitStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
    }
}

extension FilterViewController: SubmitProtocol {
    @objc func submit() {}
    @objc func initFilter() {}
}
