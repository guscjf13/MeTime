//
//  ListHeaderView.swift
//  MeTime
//
//  Created by hyunchul on 2023/09/14.
//

import Foundation
import SnapKit

protocol ListHeaderDelegate: AnyObject {
    func initFilter()
    func changeBeverage(beverage: BeverageItem, subIndex: Int)
    func presentFilter(beverage: BeverageItem, filterType: ListFilterType)
}

enum ListFilterType {
    case initAll
    case price
    case flavor
    case capacity
    
    var description: String {
        switch self {
        case .price:
            return "가격대"
        case .flavor:
            return "맛"
        case .capacity:
            return "용량"
        default:
            return ""
        }
    }
}

struct ListFilter {
    var filterType: ListFilterType
    var description: String = ""
}

final class ListHeaderView: UIView {
    
    private lazy var titleView: MainTitleView = {
        let titleView = MainTitleView(type: .list)
        return titleView
    }()
    
    private var currentBeverage: BeverageItem = .all {
        didSet {
            makeFilterList()
        }
    }
    private var currentSubIndex: Int = 0
    
    private lazy var beverageTabBar: BeverageTabBar = {
        let tabBar = BeverageTabBar()
        tabBar.delegate = self
        return tabBar
    }()
    
    private lazy var tapBarSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private var filterList: [ListFilter] = []
    private lazy var filterListCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        layout.estimatedItemSize = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(ListFilterCell.self)
        
        return collectionView
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray50
        return view
    }()
    
    weak var delegate: ListHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        addSubview(titleView)
        addSubview(beverageTabBar)
        addSubview(tapBarSeparator)
        addSubview(filterListCollectionView)
        addSubview(separator)
        
        makeFilterList()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeFilter(filter: ListFilter) {
        changeFilterDescription(filter: filter)
        
        guard let firstFilter = filterList.first, firstFilter.filterType != .initAll else { return }
        
        var isFiltered = false
        for filter in filterList {
            guard filter.filterType != .initAll, !filter.description.isEmpty else { continue }
            isFiltered = true
        }
        
        guard isFiltered else { return }
        
        filterList.insert(ListFilter(filterType: .initAll), at: 0)
        filterListCollectionView.reloadData()
    }
    
    private func changeFilterDescription(filter: ListFilter) {
        guard let index = filterList.firstIndex(where: { $0.filterType == filter.filterType }) else { return }
        
        filterList[index].description = filter.description
        filterListCollectionView.reloadData()
    }
    
    private func initFilter() {
        makeFilterList()
        delegate?.initFilter()
    }
    
    private func makeFilterList() {
        switch currentBeverage {
        case .all:
            filterList = [ListFilter(filterType: .price)]
        case .beer:
            filterList = [ListFilter(filterType: .price)]
        case .wine:
            filterList = [ListFilter(filterType: .price), ListFilter(filterType: .flavor)]
        case .whiskey:
            filterList = [ListFilter(filterType: .price), ListFilter(filterType: .capacity)]
        case .etc:
            filterList = [ListFilter(filterType: .price), ListFilter(filterType: .capacity)]
        }
        
        filterListCollectionView.reloadData()
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
            make.bottom.equalTo(tapBarSeparator.snp.top)
            make.height.equalTo(tabBarHeight)
        }
        
        tapBarSeparator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(filterListCollectionView.snp.top)
            make.height.equalTo(1)
        }
        
        filterListCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(separator.snp.top)
            make.height.equalTo(65)
        }
        
        separator.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
    }
}

extension ListHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListFilterCell.identifier, for: indexPath) as? ListFilterCell else {
            return UICollectionViewCell()
        }
        
        let filter = filterList[indexPath.row]
        
        if filter.description.isEmpty {
            cell.title = filter.filterType.description
            cell.titleColor = .white
        } else {
            cell.title = filter.description
            cell.titleColor = .MTOrange100
        }
        cell.isInitFilter = filter.filterType == .initAll
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filterType = filterList[indexPath.row].filterType
        
        guard filterType != .initAll else {
            initFilter()
            return
        }
        
        delegate?.presentFilter(beverage: currentBeverage, filterType: filterType)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let filter = filterList[indexPath.row]
        
        if filter.filterType == .initAll {
            return CGSize(width: 32, height: 66)
        } else {
            let sidePadding: CGFloat = 12
            let cellTitle = filterList[indexPath.row].description.isEmpty
                ? filter.filterType.description
                : filter.description
            let textWidth = NSString(string: cellTitle).size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width
            let textSpacing: CGFloat = 8
            let arrowImageSide: CGFloat = 12
            let width = sidePadding * 2 + textWidth + textSpacing + arrowImageSide
            
            return CGSize(width: width, height: 66)
        }
    }
}

extension ListHeaderView: BeverageTabBarDelegate {
    func changeBeverage(beverage: BeverageItem, subIndex: Int) {
        currentBeverage = beverage
        currentSubIndex = subIndex
        
        delegate?.changeBeverage(beverage: beverage, subIndex: subIndex)
        
        setNeedsUpdateConstraints()
    }
}
