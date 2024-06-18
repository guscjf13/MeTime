//
//  PriceFilterView.swift
//  MeTime
//
//  Created by hyunchul on 2023/10/27.
//

import Foundation
import UIKit

protocol PriceFilterProtocol: AnyObject {
    func changePrice(priceRange: PriceRange)
}

struct PriceRange {
    var minimum: Int
    var maximum: Int
}

class PriceFilterView: UIView {
    
    weak var delegate: PriceFilterProtocol?
    
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
    
    private lazy var firstCircle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.gray800.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .white
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(panGesture)
        return view
    }()
    
    private lazy var secondCircle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.gray800.cgColor
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
        label.text = "최소 금액"
        return label
    }()
    
    private lazy var mediumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray500
        label.text = "25,000원"
        return label
    }()
    
    private lazy var maximumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray500
        label.text = "최대 50,000원"
        return label
    }()
    
    private lazy var mediumIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    let maximumPrice: Int = 50000
    let interval: Int = 1000
    
    var priceRange = PriceRange(minimum: 0, maximum: 50000) {
        didSet {
            initPrice()
        }
    }
    
    private var minimumLevel: Int = 0 {
        didSet {
            setPriceRange()
        }
    }
    private var maximumLevel: Int = 50 {
        didSet {
            setPriceRange()
        }
    }
    
    private let backgroundViewWidth = UIScreen.main.bounds.width - 64
    
    private var levelLimit: Int {
        return maximumPrice / interval
    }
    
    private var oneLevel: CGFloat{
        return backgroundViewWidth / CGFloat(levelLimit)
    }
    
    var tempFirstCircleInset: CGFloat = 0
    var tempSecondCircleInset: CGFloat = 0
    var firstCircleInset: CGFloat = 0
    var secondCircleInset: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundView)
        addSubview(foregroundView)
        addSubview(firstCircle)
        addSubview(secondCircle)
        addSubview(minimumLabel)
        addSubview(mediumLabel)
        addSubview(maximumLabel)
        addSubview(mediumIndicator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        guard let targetView = recognizer.view else { return }
        
        guard minimumLevel >= 0 && maximumLevel <= levelLimit && minimumLevel < maximumLevel else {
            initTempInset()
            return
        }
        
        let transition = recognizer.translation(in: targetView)
        let changedX = transition.x
        recognizer.setTranslation(CGPoint.zero, in: targetView)
        
        switch targetView {
            
        case firstCircle:
            tempFirstCircleInset += changedX
            let nextLevel = Int(tempFirstCircleInset / oneLevel)
            
            guard nextLevel != minimumLevel && nextLevel >= 0 && nextLevel < maximumLevel else { return }
            
            minimumLevel = nextLevel
            firstCircleInset = tempFirstCircleInset
            
        case secondCircle:
            tempSecondCircleInset -= changedX
            let nextLevel = levelLimit - Int(tempSecondCircleInset / oneLevel)
            
            guard nextLevel != maximumLevel && nextLevel <= levelLimit && nextLevel > minimumLevel else { return }
            
            maximumLevel = nextLevel
            secondCircleInset = tempSecondCircleInset
            
        default:
            return
        }
        
        setNeedsUpdateConstraints()
    }
    
    func initFilter() {
        tempFirstCircleInset = 0
        tempSecondCircleInset = 0
        firstCircleInset = 0
        secondCircleInset = 0
        
        minimumLevel = 0
        maximumLevel = 50
        
        delegate?.changePrice(priceRange: PriceRange(minimum: 0, maximum: 50000))
        
        setNeedsUpdateConstraints()
    }
    
    private func initPrice() {
        minimumLevel = priceRange.minimum / interval
        maximumLevel = priceRange.maximum / interval
        firstCircleInset = CGFloat(minimumLevel) * oneLevel
        secondCircleInset = CGFloat(50 - maximumLevel) * oneLevel
        
        initTempInset()
        
        setNeedsUpdateConstraints()
    }
    
    private func initTempInset() {
        tempFirstCircleInset = firstCircleInset
        tempSecondCircleInset = secondCircleInset
    }
    
    private func setPriceRange() {
        let currentMinimumPrice = minimumLevel * interval
        let currentMaximumPrice = maximumLevel * interval
        delegate?.changePrice(
            priceRange: PriceRange(
                minimum: currentMinimumPrice,
                maximum: currentMaximumPrice
            )
        )
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        backgroundView.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.top).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(backgroundViewWidth)
            make.height.equalTo(4)
        }
        
        foregroundView.snp.remakeConstraints { make in
            make.centerY.equalTo(self.snp.top).offset(12)
            make.leading.equalTo(firstCircle)
            make.trailing.equalTo(secondCircle)
            make.height.equalTo(4)
        }
        
        firstCircle.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(firstCircleInset)
            make.width.height.equalTo(24)
        }
        
        secondCircle.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(secondCircleInset)
            make.width.height.equalTo(24)
        }
        
        minimumLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
        }
        
        mediumLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        maximumLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
        }
        
        mediumIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
            make.width.equalTo(1)
            make.height.equalTo(8)
        }
    }
}
