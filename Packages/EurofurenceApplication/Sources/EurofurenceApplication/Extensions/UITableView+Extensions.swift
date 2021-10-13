import ComponentBase
import UIKit

extension UITableView {
    
    func register<T>(_ cellType: T.Type) where T: UITableViewCell {
        T.registerNib(in: self)
    }
    
    func register<T>(classForCell cellType: T.Type) where T: UITableViewCell {
        let cellName = String(describing: T.self)
        register(T.self, forCellReuseIdentifier: cellName)
    }

}
