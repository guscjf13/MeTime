//
//  BeverageTabBar.swift
//  MeTime
//
//  Created by hyunchul on 2023/09/18.
//

import Foundation
import SnapKit

enum BeverageItem: Int, CaseIterable {
    case all = 0
    case beer
    case wine
    case whiskey
    case etc
    
    var name: String {
        switch self {
        case .all:
            return "전체"
        case .beer:
            return "맥주"
        case .wine:
            return "와인"
        case .whiskey:
            return "위스키"
        case .etc:
            return "기타"
        }
    }
    
    var hasSubItems: Bool {
        return !subTypes.isEmpty
    }
    
    var subTypes: [String] {
        switch self {
        case .beer:
            return ["전체", "라거", "밀맥주", "에일", "흑맥주"]
        case .wine:
            return ["전체", "레드", "화이트", "스파클링", "로제"]
        case .etc:
            return ["전체", "리큐르", "보드카"]
        default:
            return []
        }
    }
}

protocol BeverageTabBarDelegate: AnyObject {
    func changeBeverage(beverage: BeverageItem, subIndex: Int)
}

final class BeverageTabBar: UIView {
    
    private var selectedSubIndex: Int = 0
    private var selectedBeverage: BeverageItem = .all {
        didSet {
            guard selectedBeverage != oldValue else { return }
            makeSubScrollView()
            update()
        }
    }
    
    private var mainItems = [BeverageItem]()
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var subButtons = [UIButton]()
    private lazy var subScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .gray100
        return scrollView
    }()
    
    weak var delegate: BeverageTabBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addSubview(mainStackView)
        addSubview(subScrollView)
        
        makeMainStackView()
        makeSubScrollView()
        
        update()
        layoutViews()
    }
    
    private func makeMainStackView() {
        BeverageItem.allCases.forEach{
            mainItems.append($0)
        }
        
        mainItems.forEach { item in
            let button = UIButton()
            button.tag = item.rawValue
            button.addTarget(self, action: #selector(changeBeverage(sender:)), for: .touchUpInside)
            button.backgroundColor = .white
            button.titleLabel?.font = .boldSystemFont(ofSize: 14)
            button.setTitle(item.name, for: .normal)
            button.setTitleColor(.gray400, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.setTitleColor(.black, for: .highlighted)
            mainStackView.addArrangedSubview(button)
        }
    }
    
    private func makeSubScrollView() {
        guard !selectedBeverage.subTypes.isEmpty else { return }
        
        subButtons = []
        subScrollView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let subTypes = selectedBeverage.subTypes
        var previousButton: UIButton?
        var contentWidth: CGFloat = 0
        for (index, typeName) in subTypes.enumerated() {
            let button = makeSubButton(index, typeName)
            subButtons.append(button)
            subScrollView.addSubview(button)
            
            let buttonWidth = button.intrinsicContentSize.width
            let leftView = previousButton ?? subScrollView
            let leftPadding: CGFloat = previousButton == nil ? 20 : 32
            button.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.leading.equalTo(leftView.snp.trailing).offset(leftPadding)
                make.height.equalTo(46)
            }
            contentWidth += buttonWidth + leftPadding
            
            previousButton = button
        }
        contentWidth += 20
        subScrollView.contentSize = CGSize(width: contentWidth, height: 46)
        
        selectedSubIndex = 0
    }
    
    private func makeSubButton(_ index: Int, _ typeName: String) -> UIButton {
        let button = UIButton()
        button.tag = index
        button.addTarget(self, action: #selector(changeSubIndex(sender:)), for: .touchUpInside)
        button.backgroundColor = .gray100
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.setTitle(typeName, for: .normal)
        button.setTitleColor(.gray500, for: .normal)
        button.setTitleColor(.gray900, for: .selected)
        button.setTitleColor(.gray900, for: .highlighted)
        
        return button
    }
    
    private func update() {
        guard let buttons = mainStackView.arrangedSubviews as? [UIButton] else { return }
        
        for (index, _) in mainItems.enumerated() {
            guard index < buttons.count else { continue }

            let isItemSelected = selectedBeverage.rawValue == index
            let button = buttons[index]
            button.isSelected = isItemSelected
        }
        
        for (index, _) in subButtons.enumerated() {
            let isItemSelected = selectedSubIndex == index
            let button = subButtons[index]
            button.isSelected = isItemSelected
        }
        
        delegate?.changeBeverage(
            beverage: selectedBeverage,
            subIndex: selectedSubIndex
        )
    }
    
    @objc
    private func changeBeverage(sender: UIButton) {
        selectedBeverage = BeverageItem(rawValue: sender.tag) ?? .all
    }
    
    @objc
    private func changeSubIndex(sender: UIButton) {
        selectedSubIndex = sender.tag
        update()
    }
    
    private func layoutViews() {
        mainStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
        }
        
        subScrollView.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(46)
        }
    }
}
