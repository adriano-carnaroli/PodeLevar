//
//  UITableViewCell.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 29/04/21.
//

import UIKit

extension UITableViewCell {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static var registerCell: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
