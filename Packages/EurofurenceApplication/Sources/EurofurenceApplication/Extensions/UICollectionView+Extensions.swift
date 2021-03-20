import UIKit

extension UICollectionView {

    func register<T>(_ cellType: T.Type) where T: UICollectionViewCell {
        let cellName = String(describing: T.self)
        let nib = UINib(nibName: cellName, bundle: .module)
        register(nib, forCellWithReuseIdentifier: cellName)
    }

}
