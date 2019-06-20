import UIKit

extension UITableView {
    
    func register<T>(_ cellType: T.Type) where T: UITableViewCell {
        let cellName = String(describing: T.self)
        let nib = UINib(nibName: cellName, bundle: .main)
        register(nib, forCellReuseIdentifier: cellName)
    }

    func dequeue<T>(_ cellType: T.Type) -> T where T: UITableViewCell {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier) as? T else {
            abortDueToUnregisteredOrMissingCell(cellType, identifier: identifier)
        }

        return cell
    }

    func dequeue<T>(_ cellType: T.Type, for indexPath: IndexPath) -> T where T: UITableViewCell {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            abortDueToUnregisteredOrMissingCell(cellType, identifier: identifier)
        }

        return cell
    }
    
    func registerConventionBrandedHeader() {
        let headerType = ConventionBrandedTableViewHeaderFooterView.self
        register(headerType, forHeaderFooterViewReuseIdentifier: headerType.identifier)
    }
    
    func dequeueConventionBrandedHeader() -> ConventionBrandedTableViewHeaderFooterView {
        let identifier = ConventionBrandedTableViewHeaderFooterView.identifier
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? ConventionBrandedTableViewHeaderFooterView else {
            fatalError("\(ConventionBrandedTableViewHeaderFooterView.self) is not registered in this table view!")
        }
        
        return header
    }

    private func abortDueToUnregisteredOrMissingCell<T>(_ type: T.Type, identifier: String) -> Never {
        fatalError("Cell registered with identifier \"\(identifier)\" not present, or not an instance of \(type)")
    }

}
