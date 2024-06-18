//
//  UITableView +.swift
//  MeTime
//
//  Created by hyunchul on 2023/09/02.
//

import Foundation
import UIKit

extension UITableView {
    func register(_ cell: UITableViewCell.Type) {
        register(cell, forCellReuseIdentifier: cell.identifier)
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
