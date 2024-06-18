//
//  MainTabBarViewController.swift
//  MeTime
//
//  Created by hyunchul on 2023/08/29.
//

import Foundation
import UIKit
import SnapKit

final class MainTabBarViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let tabItem = MainTabBar.TabItem(rawValue: tabBarIndex) ?? .home
        
        switch tabItem {
        case .home:
            return .lightContent
        default:
            return .darkContent
        }
    }
    
    private lazy var tabBar: MainTabBar = {
        let tabBar = MainTabBar()
        tabBar.delegate = self
        return tabBar
    }()
    private var tabBarIndex: Int = 0
    
    private var childVCs = [UIViewController]()
    private var childView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tabBar)
        
        tabBar.tabItems.forEach { item in
            switch item {
            case .home:
                childVCs.append(HomeViewController())
            case .list:
                childVCs.append(ListViewController())
            case .favorite:
                childVCs.append(FavoriteViewController())
            }
        }
        
        changeViewController(index: tabBarIndex)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        childView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(tabBar.snp.top)
        }
        
        tabBar.snp.remakeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(85)
        }
    }
}

extension MainTabBarViewController: MainTabBarDelegate {
    func changeViewController(index: Int) {
        
        if index != tabBarIndex {
            childVCs[tabBarIndex].removeFromParent()
            childView.removeFromSuperview()
            
            tabBarIndex = index
        }
        
        addChild(childVCs[tabBarIndex])
        childView = childVCs[tabBarIndex].view
        view.addSubview(childView)
        childVCs[tabBarIndex].didMove(toParent: self)
        
        view.setNeedsUpdateConstraints()
        setNeedsStatusBarAppearanceUpdate()
    }
}
