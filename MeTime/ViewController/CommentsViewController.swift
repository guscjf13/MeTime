//
//  CommentsViewController.swift
//  MeTime
//
//  Created by hyunchul on 2023/11/26.
//

import Foundation
import UIKit

class CommentsViewController: UIViewController {
    
    var comments: [String] = [] {
        didSet {
            update()
        }
    }
    
    private lazy var titleView: NavigationTitleView = {
        let titleView = NavigationTitleView()
        return titleView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(BeverageCommentRowCell.self)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTableView))
        tableView.addGestureRecognizer(tapGestureRecognizer)
        return tableView
    }()
    
    private lazy var writeCell: BeverageWriteCommentCell = {
        let cell = BeverageWriteCommentCell()
        cell.delegate = self
        cell.needAutoLayout = false
        return cell
    }()
    
    private var originContentSize: CGSize = .zero
    private var originContentOffsetY: CGFloat = .zero
    private var isKeyboardShwoing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(titleView)
        view.addSubview(tableView)
        view.addSubview(writeCell)
        
        addObserver()
        layoutViews()
    }
    
    private func update() {
        titleView.title = "댓글 \(comments.count)"
        tableView.reloadData()
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
    
    @objc
    private func didTapTableView() {
        view.endEditing(true)
    }
    
    private func layoutViews() {
        titleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(writeCell.snp.top).offset(-15)
        }
        
        writeCell.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(88)
        }
    }
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BeverageCommentRowCell.identifier, for: indexPath) as? BeverageCommentRowCell else {
            return UITableViewCell()
        }
        
        cell.comment = comments[indexPath.row]
        return cell
    }
}

extension CommentsViewController: BeverageWriteCommentProtocol {
    func writeComment(comment: String) {
        print(comment)
    }
}

extension CommentsViewController {
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
                writeCell.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight)
                }
                view.layoutIfNeeded()
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
                writeCell.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide)
                }
                view.layoutIfNeeded()
            }
        )
    }
}
