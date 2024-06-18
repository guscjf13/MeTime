//
//  HomeViewController.swift
//  MeTime
//
//  Created by hyunchul on 2023/09/01.
//

import UIKit

class HomeViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.estimatedItemSize = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    enum Section: Int, CaseIterable {
        case logo
        case title
        case banner
        case phrase
        case beverage
    }
    
    private var dataSource = [Section : Any]()
    
    private var bannerPage: Int = 0 {
        didSet {
            guard bannerPage != oldValue else { return }
            NotificationCenter.default.post(
                name: .bannerChanged,
                object: nil,
                userInfo: ["bannerPage": bannerPage]
            )
        }
    }
    
    private var beverages: [Beverage] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        registerCell()
        
        setNeedsStatusBarAppearanceUpdate()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        requestBeverageList()
    }
    
    private func registerCell() {
        collectionView.register(HomeLogoCell.self)
        collectionView.register(HomeTitleCell.self)
        collectionView.register(HomeBannerCell.self)
        collectionView.register(HomePhraseCell.self)
        collectionView.register(HomeBeverageCell.self)
    }
    
    private func requestBeverageList() {
        let pagingCondition = PagingCondition(
            cursorNo: 0,
            displayPerPage: 10,
            sort: "string",
            minPrice: 0,
            maxPrice: 100000,
            cursorDefaultValue: false
        )
        
        NetworkManager.shared.requestBeverages(pagingCondition: pagingCondition) { [weak self] beverages, _ in
            self?.beverages = beverages
            self?.collectionView.reloadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard collectionView.contentSize.height > .zero else { return }
        
        let currentY = collectionView.contentOffset.y
        let minY: CGFloat = 0
        let maxY: CGFloat = collectionView.contentSize.height - collectionView.frame.height
        
        if currentY < minY {
            collectionView.contentOffset = CGPoint(x: 0, y: minY)
        } else if currentY > maxY {
            collectionView.contentOffset = CGPoint(x: 0, y: maxY)
        }
    }
}

extension HomeViewController: HomeBeverageProtocol {
    func like() {
        print("like")
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }

        switch section {
        case .logo, .title, .banner, .phrase:
            return 1
        case .beverage:
            return beverages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }

        switch section {
        case .logo:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeLogoCell.identifier, for: indexPath) as? HomeLogoCell else { return UICollectionViewCell() }
            return cell
        case .title:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTitleCell.identifier, for: indexPath) as? HomeTitleCell else { return UICollectionViewCell() }
            return cell
        case .banner:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBannerCell.identifier, for: indexPath) as? HomeBannerCell else { return UICollectionViewCell() }
            cell.delegate = self
            return cell
        case .phrase:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePhraseCell.identifier, for: indexPath) as? HomePhraseCell else { return UICollectionViewCell() }
            return cell
        case .beverage:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBeverageCell.identifier, for: indexPath) as? HomeBeverageCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.beverage = beverages[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .beverage:
            guard let beverageID = beverages[indexPath.row].id else { return }
            let detailViewController = BeverageDetailViewController(beverageID: beverageID)
            navigationController?.pushViewController(detailViewController, animated: true)
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = Section(rawValue: indexPath.section) else { return .zero }
        
        var width = view.frame.width
        var cell: HomeCell?
        
        switch section {
        case .logo:
            cell = HomeLogoCell()
        case .title:
            cell = HomeTitleCell()
        case .banner:
            cell = HomeBannerCell()
        case .phrase:
            cell = HomePhraseCell()
        case .beverage:
            cell = HomeBeverageCell()
            width = width / 2 - 3.5
        }
        
        let height: CGFloat = cell?.estimatedHeight() ?? 0
        return CGSize(width: width, height: height)
    }
}

extension HomeViewController: HomeBannerDelegate {
    func bannerChanged(index: Int) {
        bannerPage = index
    }
}
