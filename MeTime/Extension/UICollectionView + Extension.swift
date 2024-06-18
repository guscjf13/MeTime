//
//  UICollectionView + Extension.swift
//  MeTime
//
//  Created by hyunchul on 2023/09/23.
//

import Foundation
import UIKit

extension UICollectionView {
    func register(_ cell: UICollectionViewCell.Type) {
        register(cell, forCellWithReuseIdentifier: cell.identifier)
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

class HomeCell: UICollectionViewCell, hasCellHeight {
    func estimatedHeight() -> CGFloat {
        return .zero
    }
}

protocol hasCellHeight {
    func estimatedHeight() -> CGFloat
}
