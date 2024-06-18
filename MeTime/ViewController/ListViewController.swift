//
//  ListViewController.swift
//  MeTime
//
//  Created by hyunchul on 2023/09/01.
//

import UIKit

enum MergePolicy {
    case merge
    case change
}

class ListViewController: UIViewController, UIScrollViewDelegate {
    
    private lazy var headerView: ListHeaderView = {
        let view = ListHeaderView()
        view.delegate = self
        return view
    }()
    
    private lazy var tableViewHeaderView: BeverageTableViewHeaderView = {
        let view = BeverageTableViewHeaderView()
        view.delegate = self
        return view
    }()
    
    private var maxHeight: CGFloat = 168
    private var minHeight: CGFloat = 118
    private lazy var headerViewHeight: CGFloat = maxHeight
    private var hasNext: Bool = false
    private var isReloading: Bool = false
    
    private var cursorNo: Int = 0
    private var pagingCondition: PagingCondition {
        return PagingCondition(
            cursorNo: cursorNo,
            displayPerPage: 10,
            sort: "string",
            minPrice: priceRange.minimum,
            maxPrice: priceRange.maximum,
            cursorDefaultValue: false
        )
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset.top = maxHeight
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderTopPadding = 0
        tableView.sectionFooterHeight = 0
        tableView.bounces = false
        tableView.register(ListBeverageCell.self)
        return tableView
    }()
    
    private var beverages: [Beverage] = []
    
    private var orderType: OrderType = .recommend
    private var priceRange = PriceRange(minimum: 0, maximum: 50000)
    private var capacities: [Capacity] = [.all]
    private var flavors = Flavors(sweetness: 1, acid: 1, bodied: 1)
    
    private var needPaging: Bool {
        return tableView.contentOffset.y >= tableView.contentSize.height - tableView.frame.height - 100
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(headerView)
        
        moveToTop()
        layoutViews()
        
        requestBeverageList()
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
        
        if needPaging {
            pageListIfNeeded()
        }
        
        view.setNeedsUpdateConstraints()
    }
    
    private func layoutViews() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func pageListIfNeeded() {
        guard hasNext, !isReloading else { return }
        
        isReloading = true
        
        cursorNo += 1
        requestBeverageList() { [weak self] in
            self?.isReloading = false
        }
    }
    
    private func requestBeverageList(mergePolicy: MergePolicy = .merge, completion: (() -> Void)? = nil) {
        NetworkManager.shared.requestBeverages(pagingCondition: pagingCondition) { [weak self] beverages, hasNext in
            switch mergePolicy {
            case .merge:
                self?.beverages += beverages
            case .change:
                self?.beverages = beverages
            }
            
            self?.hasNext = hasNext
            self?.tableView.reloadData()
            completion?()
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        headerView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(headerViewHeight)
        }
    }
}

extension ListViewController: ListBeverageProtocol {
    func like() {
        print("like")
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beverages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListBeverageCell.identifier, for: indexPath) as? ListBeverageCell else {
            return UITableViewCell()
        }
        
        let isFirst = indexPath.row == 0
        cell.hasTopInset = !isFirst
        cell.delegate = self
        cell.beverage = beverages[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let beverageID = beverages[indexPath.row].id else { return }
        let detailViewController = BeverageDetailViewController(beverageID: beverageID)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableViewHeaderView.totalNum = 20
        tableViewHeaderView.orderType = orderType
        return tableViewHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

extension ListViewController: ListTableViewHeaderProtocol {
    func changeOrderType() {
        let filterViewController = OrderTypeFilterViewController()
        filterViewController.orderTypeDelegate = self
        filterViewController.orderType = orderType
        self.present(filterViewController, animated: false)
    }
}

extension ListViewController: ListHeaderDelegate {
    func initFilter() {
        orderType = .recommend
        priceRange = PriceRange(minimum: 0, maximum: 50000)
        capacities = [.all]
        flavors = Flavors(sweetness: 1, acid: 1, bodied: 1)
        
        print("여기서 reload")
    }
    
    func changeBeverage(beverage: BeverageItem, subIndex: Int) {
        let needExpand = beverage.hasSubItems
        maxHeight = needExpand ? 214 : 168
        minHeight = needExpand ? 164 : 118
        
        headerViewHeight = maxHeight
        tableView.contentInset.top = maxHeight
        moveToTop()
        initFilter()
    }
    
    func presentFilter(beverage: BeverageItem, filterType: ListFilterType) {
        switch filterType {
        case .price:
            let filterViewController = PriceFilterViewController()
            filterViewController.priceRange = priceRange
            filterViewController.delegate = self
            self.present(filterViewController, animated: false)
        case .capacity:
            let filterViewController = CapacityFilterViewController()
            filterViewController.selectedCapacities = capacities
            filterViewController.delegate = self
            self.present(filterViewController, animated: false)
        case .flavor:
            let filterViewController = FlavorFilterViewController()
            filterViewController.flavors = flavors
            filterViewController.delegate = self
            self.present(filterViewController, animated: false)
        default:
            return
        }
    }
}

extension ListViewController: OrderTypeProtocol {
    func changeOrderType(orderType: OrderType) {
        self.orderType = orderType
        tableView.reloadData()
    }
}

extension ListViewController: FilterProtocol {
    func changePrice(priceRange: PriceRange) {
        guard let description = changeToPriceString(priceRange: priceRange) else { return }
        
        self.priceRange = priceRange
        let filter = ListFilter(filterType: .price, description: description)
        headerView.changeFilter(filter: filter)
        
        print("여기서 reload")
    }
    
    func changeCapacities(capacities: [Capacity]) {
        self.capacities = capacities
        
        let description = capacities.count == 1
        ? capacities[0].description
        : "\(capacities[0].description) 외 \(capacities.count - 1)"
        let filter = ListFilter(filterType: .capacity, description: description)
        headerView.changeFilter(filter: filter)
        
        print("여기서 reload")
    }
    
    func changeFlavor(flavors: Flavors) {
        self.flavors = flavors
        let description = "\(Flavor.sweetness.detailValues[flavors.sweetness - 1]), \(Flavor.acid.detailValues[flavors.acid - 1]), \(Flavor.bodied.detailValues[flavors.bodied - 1])"
        let filter = ListFilter(filterType: .flavor, description: description)
        headerView.changeFilter(filter: filter)
        
        print("여기서 reload")
    }
}
