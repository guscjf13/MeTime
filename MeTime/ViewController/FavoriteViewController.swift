//
//  FavoriteViewController.swift
//  MeTime
//
//  Created by hyunchul on 2023/09/01.
//

import UIKit

class FavoriteViewController: UIViewController, UIScrollViewDelegate {
    
    private lazy var headerView: FavoriteHeaderView = {
        let view = FavoriteHeaderView()
        view.delegate = self
        return view
    }()
    
    private lazy var tableViewHeaderView: BeverageTableViewHeaderView = {
        let view = BeverageTableViewHeaderView()
        view.orderType = .none
        return view
    }()
    
    private var maxHeight: CGFloat = 102
    private var minHeight: CGFloat = 52
    private lazy var headerViewHeight: CGFloat = maxHeight
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset.top = maxHeight
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.sectionFooterHeight = 0
        tableView.register(ListBeverageCell.self)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(headerView)
        
        moveToTop()
        
        view.setNeedsUpdateConstraints()
    }
    
    private func moveToTop() {
        tableView.setContentOffset(CGPoint(x: 0, y: -maxHeight), animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= -maxHeight {
            moveToTop()
        }
        
        if scrollView.contentOffset.y < 0 {
            headerViewHeight = max(abs(scrollView.contentOffset.y), minHeight)
        }
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        headerView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(headerViewHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListBeverageCell.identifier, for: indexPath) as? ListBeverageCell else {
            return UITableViewCell()
        }
        
        let isFirst = indexPath.row == 0
        cell.hasTopInset = !isFirst
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 임시
        let detailViewController = BeverageDetailViewController(beverageID: 0)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableViewHeaderView.totalNum = 20
        return tableViewHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
}

extension FavoriteViewController: FavoriteHeaderDelegate {
    func changeBeverage(beverage: BeverageItem, subIndex: Int) {
        let needExpand = beverage.hasSubItems
        maxHeight = needExpand ? 148 : 102
        minHeight = needExpand ? 98 : 52
        
        headerViewHeight = maxHeight
        tableView.contentInset.top = maxHeight
        moveToTop()
    }
}
