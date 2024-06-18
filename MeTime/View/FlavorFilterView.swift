//
//  FlavorFilterView.swift
//  MeTime
//
//  Created by hyunchul on 2023/11/12.
//

import Foundation
import UIKit

protocol FlavorFilterProtocol: AnyObject {
    func changeFlavor(flavor: Flavor, level: Int)
}

class FlavorFilterView: UIView {
    
    weak var delegate: FlavorFilterProtocol?
    
    static let valueLabelTopMargin: CGFloat = 32
    static let valueLabelHeight: CGFloat = 20
    static let filterViewTopMargin: CGFloat = 32
    static let filterViewHeight: CGFloat = 50
    static let filterViewBottomMargin: CGFloat = 20
    static var viewHeight: CGFloat {
        return FlavorFilterView.valueLabelTopMargin + FlavorFilterView.valueLabelHeight + FlavorFilterView.filterViewTopMargin + FlavorFilterView.filterViewHeight + FlavorFilterView.filterViewBottomMargin
    }
    
    private var flavor: Flavor = .sweetness
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .gray900
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray600
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .MTOrange500
        return label
    }()
    
    private lazy var initButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "InitFilter")
        imageView.contentMode = .scaleAspectFill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(initValue))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.layer.cornerRadius = 2
        return view
    }()

    private lazy var foregroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .MTOrange500
        view.layer.cornerRadius = 2
        return view
    }()
    
    private lazy var circle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.MTOrange500.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .white
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(panGesture)
        return view
    }()
    
    private lazy var minimumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray500
        return label
    }()
    
    private lazy var mediumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray500
        return label
    }()
    
    private lazy var maximumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray500
        return label
    }()
    
    private lazy var firstIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    private lazy var mediumIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    private lazy var thirdIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    var currentLevel: Int = 1 {
        didSet {
            setFlavor()
        }
    }
    
    private let levelLimit: Int = 5
    
    private let backgroundViewWidth = UIScreen.main.bounds.width - 64
    
    private var oneLevel: CGFloat{
        return backgroundViewWidth / CGFloat(levelLimit - 1)
    }
    
    var tempCircleInset: CGFloat = 0
    var circleInset: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        initView(level: 1)
    }
    
    convenience init(flavor: Flavor, level: Int) {
        self.init()
        
        addViews()
        
        self.flavor = flavor
        initView(level: level)
    }
    
    private func addViews() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(valueLabel)
        addSubview(initButton)
        addSubview(backgroundView)
        addSubview(foregroundView)
        addSubview(minimumLabel)
        addSubview(mediumLabel)
        addSubview(maximumLabel)
        addSubview(firstIndicator)
        addSubview(mediumIndicator)
        addSubview(thirdIndicator)
        addSubview(circle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(level: Int) {
        titleLabel.text = flavor.title
        subTitleLabel.text = flavor.subTitle
        valueLabel.text = flavor.values[level - 1]
        minimumLabel.text = flavor.minimumDegree
        mediumLabel.text = flavor.mediumDegree
        maximumLabel.text = flavor.maximumDegree
        
        currentLevel = level
        circleInset = CGFloat(level - 1) * oneLevel
        
        initTempInset()
        
        setNeedsUpdateConstraints()
    }
    
    @objc
    private func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        guard let targetView = recognizer.view else { return }
        
        switch recognizer.state {
        case .changed:
            guard currentLevel >= 1 && currentLevel <= levelLimit else {
                initTempInset()
                return
            }
            
            let transition = recognizer.translation(in: targetView)
            let changedX = transition.x
            recognizer.setTranslation(CGPoint.zero, in: targetView)
            
            tempCircleInset += changedX
            var nextLevel = currentLevel
            
            if tempCircleInset >= CGFloat(currentLevel + 1 - 1) * oneLevel {
                nextLevel = currentLevel + 1
            } else if tempCircleInset <= CGFloat(currentLevel - 1 - 1) * oneLevel {
                nextLevel = currentLevel - 1
            }
            
            guard nextLevel != currentLevel && nextLevel >= 1 && nextLevel <= levelLimit else { return }
            
            currentLevel = nextLevel
            circleInset = CGFloat(nextLevel - 1) * oneLevel
            
            setNeedsUpdateConstraints()
        case .ended:
            initTempInset()
        default:
            return
        }
    }
    
    @objc
    private func initValue() {
        tempCircleInset = 0
        circleInset = 0
        
        currentLevel = 1
        
        setNeedsUpdateConstraints()
    }
    
    private func initTempInset() {
        tempCircleInset = circleInset
    }
    
    private func setFlavor() {
        valueLabel.text = flavor.values[currentLevel - 1]
        delegate?.changeFlavor(flavor: flavor, level: currentLevel)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.leading.equalToSuperview()
            make.height.equalTo(16)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(4)
            make.bottom.equalTo(titleLabel)
        }
        
        initButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.trailing.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.trailing.equalTo(initButton.snp.leading).offset(-8)
        }
        
        circle.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(circleInset)
            make.width.height.equalTo(24)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.centerY.equalTo(circle)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
        
        foregroundView.snp.remakeConstraints { make in
            make.centerY.equalTo(circle)
            make.leading.equalToSuperview()
            make.trailing.equalTo(circle)
            make.height.equalTo(4)
        }
        
        minimumLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(32)
        }
        
        mediumLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(32)
        }
        
        maximumLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(32)
        }
        
        firstIndicator.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom)
            make.leading.equalTo(backgroundView).offset(oneLevel + 12)
            make.width.equalTo(1)
            make.height.equalTo(8)
        }
        
        mediumIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(backgroundView.snp.bottom).offset(8)
            make.width.equalTo(1)
            make.height.equalTo(8)
        }
        
        thirdIndicator.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom)
            make.trailing.equalTo(backgroundView).offset(-(oneLevel + 12))
            make.width.equalTo(1)
            make.height.equalTo(8)
        }
    }
}
