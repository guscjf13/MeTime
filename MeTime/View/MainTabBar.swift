//
//  MainTabBar.swift
//  MeTime
//
//  Created by hyunchul on 2023/09/01.
//

import Foundation
import UIKit
import SnapKit

protocol MainTabBarDelegate: AnyObject {
    func changeViewController(index: Int)
}

final class MainTabBar: UIView {
    
    enum TabItem: Int, CaseIterable {
        case home
        case list
        case favorite
        
        var normalImage: UIImage? {
            switch self {
            case .home:
                return UIImage(named: "HomeUnselected")
            case .list:
                return UIImage(named: "ListUnselected")
            case .favorite:
                return UIImage(named: "FavoriteUnselected")
            }
        }
        
        var selectedImage: UIImage? {
            switch self {
            case .home:
                return UIImage(named: "HomeSelected")
            case .list:
                return UIImage(named: "ListSelected")
            case .favorite:
                return UIImage(named: "FavoriteSelected")
            }
        }
    }
    
    var tabItems = [TabItem]()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var selectedIndex: Int = 0 {
        didSet {
            guard selectedIndex != oldValue else { return }
            update()
        }
    }
    
    weak var delegate: MainTabBarDelegate?
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUp() {
        addSubview(stackView)
        addSubview(separator)
        
        TabItem.allCases.forEach{
            tabItems.append($0)
        }
        
        tabItems.forEach { item in
            let button = UIButton()
            button.tag = item.rawValue
            button.addTarget(self, action: #selector(buttonTouched(sender:)), for: .touchUpInside)
            button.backgroundColor = .white
            button.setImage(item.normalImage, for: .normal)
            button.setImage(item.selectedImage, for: .selected)
            button.setImage(item.selectedImage, for: .highlighted)
            stackView.addArrangedSubview(button)
        }
        
        update()
        layoutViews()
    }
    
    private func update() {
        guard let buttons = stackView.arrangedSubviews as? [UIButton] else { return }
        
        for (index, _) in tabItems.enumerated() {
            guard index < buttons.count else { continue }

            let isItemSelected = selectedIndex == index
            let button = buttons[index]
            button.isSelected = isItemSelected
        }
        
        delegate?.changeViewController(index: selectedIndex)
    }
    
    @objc
    private func buttonTouched(sender: UIButton) {
        guard let index = TabItem(rawValue: sender.tag)?.rawValue else { return }
        
        selectedIndex = index
    }
    
    private func layoutViews() {
        separator.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
}
