//
//  HomeBannerCell.swift
//  MeTime
//
//  Created by hyunchul on 2023/09/04.
//

import Foundation
import UIKit
import SnapKit

protocol HomeBannerDelegate: AnyObject {
    func bannerChanged(index: Int)
}

final class HomeBannerCell: HomeCell, UIScrollViewDelegate {
    
    private lazy var firstBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray900
        return view
    }()
    
    private lazy var secondBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .clear
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = false
        return scrollView
    }()
    
    private lazy var indicator = BannerIndicator()
    
    private let bannerSide: CGFloat = 320
    private let bannerPadding: CGFloat = 10
    private var scrollViewWidth: CGFloat {
        return bannerSide + bannerPadding
    }
    
    weak var delegate: HomeBannerDelegate?
    
    private var currentPage: Int = 0 {
        didSet {
            delegate?.bannerChanged(index: currentPage)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .gray900
        
        addSubview(firstBgView)
        addSubview(secondBgView)
        addSubview(scrollView)
        addSubview(indicator)
        
        addContentScrollView()
        layoutViews()
    }
    
    private func addContentScrollView() {
        for index in 0...4 {
            let view = UIView()
            let xPos = scrollViewWidth * CGFloat(index) + bannerPadding / 2
            view.frame = CGRect(
                x: xPos,
                y: 0,
                width: bannerSide,
                height: bannerSide
            )
            switch index {
            case 0:
                view.backgroundColor = .red
            case 1:
                view.backgroundColor = .yellow
            case 2:
                view.backgroundColor = .green
            case 3:
                view.backgroundColor = .blue
            case 4:
                view.backgroundColor = .purple
            default:
                break
            }
            scrollView.addSubview(view)
            scrollView.contentSize.width += scrollViewWidth
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        indicator.ratio = (scrollView.contentOffset.x / ((5-1) * scrollViewWidth))
        
        let nextPage = Int(scrollView.contentOffset.x) / Int(scrollViewWidth)
        
        guard
            currentPage != nextPage,
            (scrollView.contentOffset.x / scrollViewWidth) - CGFloat(nextPage) < 0.1
        else {
            return
        }
        
        currentPage = nextPage
    }
    
    private func layoutViews() {
        firstBgView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(272)
        }
        
        secondBgView.snp.makeConstraints { make in
            make.top.equalTo(firstBgView.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(scrollViewWidth)
            make.height.equalTo(bannerSide)
        }
        
        indicator.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(14)
            make.leading.equalToSuperview().inset(28)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(4)
        }
    }
    
    override func estimatedHeight() -> CGFloat {
        return bannerSide + 14 + 4
    }
}

extension HomeBannerCell {
    private final class BannerIndicator: UIView {
        
        private lazy var indicatorView: UIView = {
            let view = UIView()
            view.backgroundColor = .gray900
            return view
        }()
        
        var ratio: Double = 0 {
            didSet {
                guard ratio >= 0 else { return }
                update()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUp()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setUp() {
            backgroundColor = .gray100
            
            addSubview(indicatorView)
        }
        
        private func update() {
            let width = self.frame.width
            let indicatorWidth = width * self.ratio
            
            indicatorView.snp.remakeConstraints { make in
                make.top.leading.bottom.equalToSuperview()
                make.width.equalTo(indicatorWidth)
            }
        }
        
        override func updateConstraints() {
            super.updateConstraints()
            
            indicatorView.snp.makeConstraints { make in
                make.top.leading.bottom.equalToSuperview()
                make.width.equalTo(0)
            }
        }
    }
}
