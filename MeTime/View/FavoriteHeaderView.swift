//
//  FavoriteHeaderView.swift
//  MeTime
//
//  Created by hyunchul on 2023/12/05.
//

import Foundation
import SnapKit

protocol FavoriteHeaderDelegate: AnyObject {
    func changeBeverage(beverage: BeverageItem, subIndex: Int)
}

final class FavoriteHeaderView: UIView {
    
    private lazy var titleView: MainTitleView = {
        let titleView = MainTitleView(type: .favorite)
        return titleView
    }()
    
    private var currentBeverage: BeverageItem = .all
    private var currentSubIndex: Int = 0
    
    private lazy var beverageTabBar: BeverageTabBar = {
        let tabBar = BeverageTabBar()
        tabBar.delegate = self
        return tabBar
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    weak var delegate: FavoriteHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        addSubview(titleView)
        addSubview(beverageTabBar)
        addSubview(separator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        titleView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(beverageTabBar.snp.top)
            make.height.equalTo(50)
        }
        
        beverageTabBar.snp.remakeConstraints { make in
            let tabBarHeight = currentBeverage.hasSubItems ? 98 : 52
            
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(tabBarHeight)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(beverageTabBar.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

extension FavoriteHeaderView: BeverageTabBarDelegate {
    func changeBeverage(beverage: BeverageItem, subIndex: Int) {
        currentBeverage = beverage
        currentSubIndex = subIndex
        
        delegate?.changeBeverage(beverage: beverage, subIndex: subIndex)
        
        setNeedsUpdateConstraints()
    }
}

