//
//  FlavorFilterViewController.swift
//  MeTime
//
//  Created by hyunchul on 2023/11/12.
//

import Foundation
import UIKit

class FlavorFilterViewController: FilterViewController {
    
    var flavors = Flavors(sweetness: 1, acid: 1, bodied: 1)
    
    override var contentHeight: CGFloat {
        return FlavorFilterView.viewHeight * 3
    }
    
    private lazy var sweetNessFilterView: FlavorFilterView = {
        let filterView = FlavorFilterView(flavor: .sweetness, level: flavors.sweetness)
        filterView.delegate = self
        return filterView
    }()
    
    private lazy var acidFilterView: FlavorFilterView = {
        let filterView = FlavorFilterView(flavor: .acid, level: flavors.acid)
        filterView.delegate = self
        return filterView
    }()
    
    private lazy var bodiedFilterView: FlavorFilterView = {
        let filterView = FlavorFilterView(flavor: .bodied, level: flavors.bodied)
        filterView.delegate = self
        return filterView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "맛"
        
        contentView.addSubview(sweetNessFilterView)
        contentView.addSubview(acidFilterView)
        contentView.addSubview(bodiedFilterView)
        
        layoutViews()
    }
    
    private func layoutViews() {
        sweetNessFilterView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(FlavorFilterView.viewHeight)
        }
        
        acidFilterView.snp.makeConstraints { make in
            make.top.equalTo(sweetNessFilterView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(FlavorFilterView.viewHeight)
        }

        bodiedFilterView.snp.makeConstraints { make in
            make.top.equalTo(acidFilterView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(FlavorFilterView.viewHeight)
        }
    }
}

extension FlavorFilterViewController: FlavorFilterProtocol {
    func changeFlavor(flavor: Flavor, level: Int) {
        switch flavor {
        case .sweetness:
            flavors.sweetness = level
        case .acid:
            flavors.acid = level
        case .bodied:
            flavors.bodied = level
        }
    }
}

extension FlavorFilterViewController {
    override func initFilter() {
        sweetNessFilterView.initView(level: 1)
        acidFilterView.initView(level: 1)
        bodiedFilterView.initView(level: 1)
    }

    override func submit() {
        delegate?.changeFlavor(flavors: flavors)
        dismissView()
    }
}


struct Flavors {
    var sweetness: Int
    var acid: Int
    var bodied: Int
}

enum Flavor: CaseIterable {
    case sweetness
    case acid
    case bodied
    
    var title: String {
        switch self {
        case .sweetness:
            return "당도"
        case .acid:
            return "산도"
        case .bodied:
            return "바디"
        }
    }
    
    var subTitle: String {
        switch self {
        case .sweetness:
            return "단맛"
        case .acid:
            return "신맛"
        case .bodied:
            return "진한 정도"
        }
    }
    
    var description: String {
        switch self {
        case .sweetness:
            return "단 맛에 데한 표현"
        case .acid:
            return "신 맛에 대한 표현"
        case .bodied:
            return "입에서 느껴지는 무게감 표현"
        }
    }
    
    var values: [String] {
        switch self {
        case .sweetness:
            return ["Dry", "Off Dry", "Semi Sweet", "Medium Sweet", "Sweet"]
        case .acid, .bodied:
            return ["1단계", "2단계", "3단계", "4단계", "5단계"]
        }
    }
    
    var style: [String] {
        switch self {
        case .sweetness:
            return ["드라이", "오프 드라이", "세미 스위트", "미디움 스위트", "스위트"]
        case .acid:
            return ["산미 없음", "산도 약함", "산도 중간", "산도 있음", "산도 강함"]
        case .bodied:
            return ["맑음", "맑은 편", "바디 보통", "묵직한 편", "묵직함"]
        }
    }
    
    var detailValues: [String] {
        switch self {
        case .sweetness:
            return values
        case .acid, .bodied:
            return values.map { "\(title) \($0)" }
        }
    }
    
    var minimumDegree: String {
        switch self {
        case .sweetness:
            return "Dry(단 맛없음)"
        case .acid:
            return "1단계(신 맛없음)"
        case .bodied:
            return "1단계(맑은)"
        }
    }
    
    var mediumDegree: String {
        switch self {
        case .sweetness:
            return "Semi Sweet(이온음료)"
        case .acid:
            return "3단계(오렌지)"
        case .bodied:
            return "3단계"
        }
    }
    
    var maximumDegree: String {
        switch self {
        case .sweetness:
            return "Sweet(사탕)"
        case .acid:
            return "5단계(식초)"
        case .bodied:
            return "5단계(꾸덕)"
        }
    }
}
