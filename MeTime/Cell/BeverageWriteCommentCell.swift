//
//  BeverageCommentWriteCell.swift
//  MeTime
//
//  Created by hyunchul on 2023/11/19.
//

import Foundation
import UIKit

protocol BeverageWriteCommentProtocol: AnyObject {
    func writeComment(comment: String)
}

class BeverageWriteCommentCell: UITableViewCell {
    
    weak var delegate: BeverageWriteCommentProtocol?
    
    let commentPlaceHolder: String = "댓글 작성하기"
    
    var isWriting: Bool = false
    var isSeparatorHidden: Bool = false {
        didSet {
            separator.isHidden = isSeparatorHidden
            setNeedsUpdateConstraints()
        }
    }
    var needAutoLayout: Bool = false {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray50
        return view
    }()
    
    private lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.text = commentPlaceHolder
        textView.textColor = .gray500
        textView.font = .systemFont(ofSize: 14)
        textView.layer.cornerRadius = 4
        textView.layer.borderColor = UIColor.gray100.cgColor
        textView.layer.borderWidth = 1
        textView.textContainerInset = UIEdgeInsets(top: 14, left: 12.0, bottom: 14, right: 36.0)
        textView.delegate = self
        
        return textView
    }()
    
    private lazy var commentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Send")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .gray100
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(writeComment))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(separator)
        contentView.addSubview(commentTextView)
        contentView.addSubview(commentImageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    @objc
    private func writeComment() {
        guard let comment = commentTextView.text, !comment.isEmpty, isWriting else { return }
        delegate?.writeComment(comment: comment)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        separator.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        commentTextView.snp.remakeConstraints { make in
            if isSeparatorHidden {
                make.top.equalToSuperview().inset(20)
            } else {
                make.top.equalTo(separator.snp.bottom).offset(20)
            }
            make.leading.trailing.equalToSuperview().inset(20)
            if needAutoLayout {
                make.bottom.equalToSuperview().inset(50)
            }
            make.height.equalTo(48)
        }
        
        commentImageView.snp.makeConstraints { make in
            make.centerY.equalTo(commentTextView)
            make.trailing.equalToSuperview().inset(32)
            make.width.height.equalTo(24)
        }
    }
}

extension BeverageWriteCommentCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.text == commentPlaceHolder else { return }
        
        textView.text = nil
        textView.textColor = .gray900
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
            
        textView.text = commentPlaceHolder
        textView.textColor = .gray500
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        
        commentImageView.tintColor = text.isEmpty ? .gray100 : .MTOrange500
        isWriting = !text.isEmpty
    }
}

