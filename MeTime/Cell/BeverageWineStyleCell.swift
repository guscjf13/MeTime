//
//  BeverageWineStyleCell.swift
//  MeTime
//
//  Created by hyunchul on 2023/11/26.
//

import Foundation
import UIKit

class BeverageWineStyleCell: UITableViewCell {
    
    var flavors = Flavors(sweetness: 3, acid: 2, bodied: 5)
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .gray800
        label.text = "와인 스타일"
        return label
    }()
    
    private lazy var subLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray600
        label.text = "한 모금씩 시음하며 미타임 모드를 더욱 풍미있게 보내세요."
        return label
    }()
    
    private lazy var sweetnessView: WineFlavorView = {
        let view = WineFlavorView(flavor: .sweetness, degree: flavors.sweetness)
        return view
    }()
    
    private lazy var acidView: WineFlavorView = {
        let view = WineFlavorView(flavor: .acid, degree: flavors.acid)
        return view
    }()
    
    private lazy var bodiedView: WineFlavorView = {
        let view = WineFlavorView(flavor: .bodied, degree: flavors.bodied)
        return view
    }()
    
    private lazy var lastSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray50
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        
        contentView.addSubview(mainLabel)
        contentView.addSubview(subLabel)
        contentView.addSubview(sweetnessView)
        contentView.addSubview(acidView)
        contentView.addSubview(bodiedView)
        contentView.addSubview(lastSeparator)

        setNeedsUpdateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(44)
            make.leading.equalToSuperview().inset(20)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(8)
            make.leading.equalTo(mainLabel)
        }
        
        sweetnessView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(82)
        }
        
        acidView.snp.makeConstraints { make in
            make.top.equalTo(sweetnessView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(82)
        }
        
        bodiedView.snp.makeConstraints { make in
            make.top.equalTo(acidView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(82)
        }
        
        lastSeparator.snp.makeConstraints { make in
            make.top.equalTo(bodiedView.snp.bottom).offset(40)
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
    }
}

class WineFlavorView: UIView {
    
    private var flavor: Flavor
    private var degree: Int
    
    private var oneLevel: CGFloat{
        let backgroundViewWidth = UIScreen.main.bounds.width - 40
        return backgroundViewWidth / 4
    }
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .gray800
        return label
    }()
    
    private lazy var subLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray500
        return label
    }()
    
    private lazy var flavorLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .MTOrange500
        label.textAlignment = .center
        label.backgroundColor = .MTOrange50
        return label
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = .gray100
        return view
    }()
    
    private lazy var foregroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = .MTOrange400
        return view
    }()
    
    private lazy var minimumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray400
        return label
    }()
    
    private lazy var mediumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray400
        return label
    }()
    
    private lazy var maximumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray400
        return label
    }()
    
    init(flavor: Flavor, degree: Int) {
        self.flavor = flavor
        self.degree = degree
        super.init(frame: .zero)
        
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(flavorLabel)
        addSubview(backgroundView)
        addSubview(foregroundView)
        addSubview(minimumLabel)
        addSubview(mediumLabel)
        addSubview(maximumLabel)
        
        mainLabel.text = flavor.title
        subLabel.text = flavor.description
        flavorLabel.text = flavor.style[degree - 1]
        minimumLabel.text = flavor.minimumDegree
        mediumLabel.text = flavor.mediumDegree
        maximumLabel.text = flavor.maximumDegree
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(mainLabel.snp.trailing).offset(4)
        }
        
        flavorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            let textWidth = NSString(string: flavorLabel.text ?? "").size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width
            let padding: CGFloat = 12
            let width = textWidth + padding * 2
            make.width.equalTo(width)
            make.height.equalTo(30)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(flavorLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(12)
        }
        
        foregroundView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView)
            make.leading.equalTo(backgroundView)
            let width = oneLevel * CGFloat(degree - 1)
            make.width.equalTo(width)
            make.height.equalTo(backgroundView)
        }
        
        minimumLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        mediumLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        maximumLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}
