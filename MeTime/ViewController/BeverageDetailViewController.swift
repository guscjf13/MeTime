//
//  BeverageDetailViewController.swift
//  MeTime
//
//  Created by hyunchul on 2023/11/16.
//

import Foundation
import UIKit

final class BeverageDetailViewController: UIViewController {
    
    private var beverageID: Int = 0
    
    private var beverage: Beverage? {
        didSet {
            update()
        }
    }
    
    var isWine: Bool = true
    
    private let titleViewHeight: CGFloat = 104
    
    private var originContentSize: CGSize = .zero
    private var originContentOffsetY: CGFloat = .zero
    private var isKeyboardShwoing: Bool = false
    
    var isDown: Bool = false {
        didSet {
            guard oldValue != isDown else { return }
            titleView.switchAppearance(showTitle: isDown)
        }
    }
    
    var comments: [String] = ["테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자", "테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자", "하하하핳하", "테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자", "테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자", "하하하핳하", "테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자", "테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자", "하하하핳하", "테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자", "테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자", "하하하핳하", "테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자", "테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자", "하하하핳하", "테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자", "테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자테스트 해보자", "하하하핳하"]
    
    private var sections: [Section] = []
    
    enum Section: Int, CaseIterable {
        case thumbnail
        case title
        case shop
        case wineStyle
        case evaluation
        case like
        case comment
        case writeComment
    }
    
    private lazy var titleView: NavigationTitleView = {
        let titleView = NavigationTitleView()
        titleView.switchAppearance(showTitle: false)
        return titleView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTableView))
        tableView.addGestureRecognizer(tapGestureRecognizer)
        return tableView
    }()
    
    init(beverageID: Int) {
        super.init(nibName: nil, bundle: nil)
        self.beverageID = beverageID
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        view.addSubview(titleView)
        
        registerCell()
        addObserver()
        makeSections()
        layoutViews()
        
        loadBeverageDetail()
    }
    
    private func registerCell() {
        tableView.register(BeverageThumbnailCell.self)
        tableView.register(BeverageTitleCell.self)
        tableView.register(BeverageShopCell.self)
        tableView.register(BeverageWineStyleCell.self)
        tableView.register(BeverageEvaluationCell.self)
        tableView.register(BeverageLikeCell.self)
        tableView.register(BeverageCommentCell.self)
        tableView.register(BeverageWriteCommentCell.self)
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func makeSections() {
        sections = isWine
        ? [.thumbnail, .title, .shop, .wineStyle, .evaluation, .like, .comment, .writeComment]
        : [.thumbnail, .title, .shop, .evaluation, .like, .comment, .writeComment]
        
        tableView.reloadData()
    }
    
    private func loadBeverageDetail() {
        NetworkManager.shared.requestBeverageDetail(beverageID: beverageID) { [weak self] beverage in
            self?.beverage = beverage
        }
    }
    
    private func update() {
        guard let beverage else { return }
        
        titleView.title = beverage.name
        tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isDown = tableView.contentOffset.y >= titleViewHeight
        
        tableView.contentOffset = CGPoint(x: 0, y: max(tableView.contentOffset.y, 0))
    }
    
    @objc
    private func didTapTableView() {
        view.endEditing(true)
    }
    
    private func layoutViews() {
        titleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(titleViewHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension BeverageDetailViewController: UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .thumbnail:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BeverageThumbnailCell.identifier) as? BeverageThumbnailCell else { return UITableViewCell() }
            cell.beverage = beverage
            return cell
        case .title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BeverageTitleCell.identifier) as? BeverageTitleCell else { return UITableViewCell() }
            cell.beverage = beverage
            return cell
        case .shop:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BeverageShopCell.identifier) as? BeverageShopCell else { return UITableViewCell() }
            cell.beverage = beverage
            return cell
        case .wineStyle:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BeverageWineStyleCell.identifier) as? BeverageWineStyleCell else { return UITableViewCell() }
            return cell
        case .evaluation:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BeverageEvaluationCell.identifier) as? BeverageEvaluationCell else { return UITableViewCell() }
            return cell
        case .like:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BeverageLikeCell.identifier) as? BeverageLikeCell else { return UITableViewCell() }
            return cell
        case .comment:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BeverageCommentCell.identifier) as? BeverageCommentCell else { return UITableViewCell() }
            cell.delegate = self
            cell.comments = comments
            return cell
        case .writeComment:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BeverageWriteCommentCell.identifier) as? BeverageWriteCommentCell else { return UITableViewCell() }
            cell.delegate = self
            cell.isSeparatorHidden = comments.isEmpty
            cell.needAutoLayout = true
            return cell
        }
    }
}

extension BeverageDetailViewController: BeverageWriteCommentProtocol {
    func writeComment(comment: String) {
        print(comment)
    }
}

extension BeverageDetailViewController {
    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            !isKeyboardShwoing else {
            return
        }
        
        isKeyboardShwoing = true
        let contentSize = tableView.contentSize
        let contentOffset = tableView.contentOffset
        let keyboardHeight = keyboardFrame.cgRectValue.height
        originContentOffsetY = contentOffset.y
        originContentSize = contentSize
        
        tableView.contentSize = CGSize(
            width: contentSize.width,
            height: contentSize.height + keyboardHeight
        )
        
        UIView.animate(
            withDuration: 0.25,
            animations: {  [weak self] in
                guard let self else { return }
                tableView.contentOffset = CGPoint(x: 0, y: contentOffset.y + keyboardHeight)
            }
        )
    }
    
    @objc
    func keyboardWillHide() {
        guard isKeyboardShwoing else { return }
        
        isKeyboardShwoing = false
        tableView.contentSize = originContentSize
        
        UIView.animate(
            withDuration: 0.25,
            animations: {  [weak self] in
                guard let self else { return }
                tableView.contentOffset = CGPoint(x: 0, y: originContentOffsetY)
            }
        )
    }
}

extension BeverageDetailViewController: BeverageCommentFooterProtocol {
    func viewMoreComment() {
        view.endEditing(true)
        
        let commentsViewController = CommentsViewController()
        commentsViewController.comments = comments
        navigationController?.pushViewController(commentsViewController, animated: true)
    }
}
