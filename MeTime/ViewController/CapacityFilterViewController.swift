//
//  CapacityFilterViewController.swift
//  MeTime
//
//  Created by hyunchul on 2023/10/28.
//

import Foundation
import UIKit

enum Capacity: Int, CaseIterable {
    case all = 0
    case mini
    case under500
    case over500under700
    case over700
    
    var description: String {
        switch self {
        case .all:
            return "전체"
        case .mini:
            return "미니어처(50ml)"
        case .under500:
            return "500ml 이하"
        case .over500under700:
            return "500 ~ 700ml 이하"
        case .over700:
            return "700ml 초과"
        }
    }
}

class CapacityFilterViewController: FilterViewController {
    
    let rowHeight: CGFloat = 60
    
    override var contentHeight: CGFloat {
        return rowHeight * CGFloat(capacityList.count) + 40
    }
    
    var selectedCapacities: [Capacity] = [.all] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var capacityList = Capacity.allCases
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight
        tableView.separatorStyle = .none
        tableView.register(FilterTextCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "용량"
        
        contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension CapacityFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return capacityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTextCell.identifier, for: indexPath) as? FilterTextCell else {
            return UITableViewCell()
        }
        
        guard let cellCapacity = Capacity(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        
        let isSelected = selectedCapacities.contains(cellCapacity)
        cell.title = capacityList[indexPath.row].description
        cell.isSelected = isSelected
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellCapacity = Capacity(rawValue: indexPath.row) else { return }
        
        if cellCapacity == .all {
            selectedCapacities = [.all]
        } else {
            selectedCapacities.removeAll(where: {$0 == .all})
            
            if selectedCapacities.contains(cellCapacity) {
                selectedCapacities.removeAll(where: {$0 == cellCapacity})
            } else {
                selectedCapacities.append(cellCapacity)
            }
        }
    }
}

extension CapacityFilterViewController {
    override func initFilter() {
        selectedCapacities = [.all]
    }

    override func submit() {
        selectedCapacities.sort { $0.rawValue < $1.rawValue }
        delegate?.changeCapacities(capacities: selectedCapacities)
        dismissView()
    }
}
