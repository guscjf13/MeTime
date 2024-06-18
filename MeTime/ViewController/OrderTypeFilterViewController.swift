//
//  OrderTypeFilterViewController.swift
//  MeTime
//
//  Created by hyunchul on 2023/11/18.
//

import Foundation
import UIKit

enum OrderType: Int, CaseIterable {
    case recommend
    case popular
    case comment
    case star
    case none
    
    var description: String {
        switch self {
        case .recommend:
            return "추천순"
        case .popular:
            return "인기순"
        case .comment:
            return "댓글순"
        case .star:
            return "별점순"
        default:
            return ""
        }
    }
}

protocol OrderTypeProtocol: AnyObject {
    func changeOrderType(orderType: OrderType)
}

class OrderTypeFilterViewController: FilterViewController {
    
    weak var orderTypeDelegate: OrderTypeProtocol?
    
    var orderType: OrderType = .recommend {
        didSet {
            tableView.reloadData()
        }
    }
    
    let rowHeight: CGFloat = 60
    
    override var contentHeight: CGFloat {
        return rowHeight * CGFloat(orderTypeList.count) + 40
    }
    
    var selectedCapacities: [Capacity] = [.all] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var orderTypeList = OrderType.allCases
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight
        tableView.separatorStyle = .none
        tableView.register(FilterTextCell.self)
        return tableView
    }()
    
    override var hasSubmitView: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "정렬"
        
        contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension OrderTypeFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderTypeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTextCell.identifier, for: indexPath) as? FilterTextCell else {
            return UITableViewCell()
        }
        
        guard let newOrderType = OrderType(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        
        let isSelected = orderType == newOrderType
        cell.title = orderTypeList[indexPath.row].description
        cell.isSelected = isSelected
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let orderType = OrderType(rawValue: indexPath.row) else { return }
        
        orderTypeDelegate?.changeOrderType(orderType: orderType)
        dismissView()
    }
}
