//
//  BeverageCommentCell.swift
//  MeTime
//
//  Created by hyunchul on 2023/11/19.
//

import Foundation
import UIKit

protocol BeverageCommentFooterProtocol: AnyObject {
    func viewMoreComment()
}

class BeverageCommentCell: UITableViewCell {
    
    weak var delegate: BeverageCommentFooterProtocol?
    
    var comments: [String] = [] {
        didSet {
            update()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .gray800
        return label
    }()
    
    private lazy var commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray400
        return label
    }()
    
    private lazy var tableView: CommentTableView = {
        let tableView = CommentTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.register(BeverageCommentRowCell.self)
        return tableView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(commentCountLabel)
        contentView.addSubview(tableView)
        
        setNeedsUpdateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private func update() {
        titleLabel.text = comments.isEmpty ? "첫 번째로 리뷰를 남겨주세요" : "댓글"
        commentCountLabel.text = String(comments.count)
        
        commentCountLabel.isHidden = comments.isEmpty
        tableView.isHidden = comments.isEmpty
        
        layoutViews()
        setNeedsUpdateConstraints()
    }
    
    private func layoutViews() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview().inset(20)
            if comments.isEmpty {
                make.bottom.equalToSuperview().inset(4)
            } else {
                make.bottom.equalTo(tableView.snp.top).offset(-32)
                make.bottom.equalTo(tableView.snp.top)
            }
        }
        
        commentCountLabel.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(7)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
    }
}

extension BeverageCommentCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let maxCount = 5
        return min(comments.count, maxCount)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BeverageCommentRowCell.identifier, for: indexPath) as? BeverageCommentRowCell else {
            return UITableViewCell()
        }
        
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = CommentFooterView()
        footer.viewMoreComment = { [weak self] in
            self?.delegate?.viewMoreComment()
        }
        
        let footerViewIsHidden = comments.count <= 5
        return footerViewIsHidden ? nil : footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let footerHeight: CGFloat = comments.count > 5 ? 50 : 0
        return footerHeight
    }
}

extension BeverageCommentCell {
    class CommentTableView: UITableView {
        
        override var intrinsicContentSize: CGSize {
          self.layoutIfNeeded()
          return self.contentSize
        }

        override var contentSize: CGSize {
          didSet{
            self.invalidateIntrinsicContentSize()
          }
        }

        override func reloadData() {
          super.reloadData()
          self.invalidateIntrinsicContentSize()
        }
    }
}

extension BeverageCommentCell {
    class CommentFooterView: UIView {
        
        var viewMoreComment: (() -> Void)?
        
        private lazy var footerLabel: UILabel = {
            let label = UILabel()
            label.font = .boldSystemFont(ofSize: 14)
            label.textColor = .gray900
            label.textAlignment = .center
            label.text = "모든 댓글 보기 >"
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(footerLabel)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapFooter))
            addGestureRecognizer(tapGestureRecognizer)
            
            footerLabel.snp.makeConstraints { make in
                make.leading.bottom.trailing.equalToSuperview()
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc
        private func didTapFooter() {
            viewMoreComment?()
        }
    }
}
