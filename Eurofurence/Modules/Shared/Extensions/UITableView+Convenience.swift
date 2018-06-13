//
//  UITableView+Convenience.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

extension UITableView {

    func register<T>(_ cellType: T.Type) where T: UITableViewCell {
        let cellName = String(describing: T.self)
        let nib = UINib(nibName: cellName, bundle: .main)
        register(nib, forCellReuseIdentifier: cellName)
    }

}
