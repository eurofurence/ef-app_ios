import ComponentBase
import UIKit

extension UITableView {
    
    func register<T>(_ cellType: T.Type) where T: UITableViewCell {
        let cellName = String(describing: T.self)
        let nib = UINib(nibName: cellName, bundle: .module)
        register(nib, forCellReuseIdentifier: cellName)
    }
    
    func register<T>(classForCell cellType: T.Type) where T: UITableViewCell {
        let cellName = String(describing: T.self)
        register(T.self, forCellReuseIdentifier: cellName)
    }

}
