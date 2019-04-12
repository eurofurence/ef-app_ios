import UIKit

extension UITableView {

    func register<T>(_ cellType: T.Type) where T: UITableViewCell {
        let cellName = String(describing: T.self)
        let nib = UINib(nibName: cellName, bundle: .main)
        register(nib, forCellReuseIdentifier: cellName)
    }

}
