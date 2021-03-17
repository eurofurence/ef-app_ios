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
    
    func customCellForRow<T>(at indexPath: IndexPath) -> T where T: UITableViewCell {
        let cell = cellForRow(at: indexPath)
        guard let castedCell = cellForRow(at: indexPath) as? T else {
            fatalError("Expected to dequeue cell of type \(T.self), got \(type(of: cell))")
        }
        
        return castedCell
    }
    
    func registerConventionBrandedHeader() {
        let headerType = ConventionBrandedTableViewHeaderFooterView.self
        register(headerType, forHeaderFooterViewReuseIdentifier: headerType.identifier)
    }
    
    func dequeueConventionBrandedHeader() -> ConventionBrandedTableViewHeaderFooterView {
        let identifier = ConventionBrandedTableViewHeaderFooterView.identifier
        let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: identifier)
        
        guard let header = headerFooterView as? ConventionBrandedTableViewHeaderFooterView else {
            fatalError("\(ConventionBrandedTableViewHeaderFooterView.self) is not registered in this table view!")
        }
        
        return header
    }
    
    func adjustScrollIndicatorInsetsForSafeAreaCompensation() {
        if #available(iOS 11.1, *) {
            horizontalScrollIndicatorInsets.right = -safeAreaInsets.right
        }
    }
    
    func deselectSelectedRow(animated: Bool = false) {
        if let indexPathForSelectedRow = indexPathForSelectedRow {
            deselectRow(at: indexPathForSelectedRow, animated: animated)
        }
    }

    private func abortDueToUnregisteredOrMissingCell<T>(_ type: T.Type, identifier: String) -> Never {
        fatalError("Cell registered with identifier \"\(identifier)\" not present, or not an instance of \(type)")
    }

}
