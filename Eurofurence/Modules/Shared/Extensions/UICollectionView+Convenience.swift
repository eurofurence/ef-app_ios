//
//  UICollectionView+Convenience.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

extension UICollectionView {

    func register<T>(_ cellType: T.Type) where T: UICollectionViewCell {
        let cellName = String(describing: T.self)
        let nib = UINib(nibName: cellName, bundle: .main)
        register(nib, forCellWithReuseIdentifier: cellName)
    }

    func dequeue<T>(_ cellType: T.Type, for indexPath: IndexPath) -> T where T: UICollectionViewCell {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            abortDueToUnregisteredOrMissingCell(cellType, identifier: identifier)
        }

        return cell
    }

    private func abortDueToUnregisteredOrMissingCell<T>(_ type: T.Type, identifier: String) -> Never {
        fatalError("Cell registered with identifier \"\(identifier)\" not present, or not an instance of \(type)")
    }

}
