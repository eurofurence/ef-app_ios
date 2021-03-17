import UIKit

extension UITableView {
    
    public func dequeue<T>(_ cellType: T.Type) -> T where T: UITableViewCell {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier) as? T else {
            abortDueToUnregisteredOrMissingCell(cellType, identifier: identifier)
        }

        return cell
    }

    public func dequeue<T>(_ cellType: T.Type, for indexPath: IndexPath) -> T where T: UITableViewCell {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            abortDueToUnregisteredOrMissingCell(cellType, identifier: identifier)
        }

        return cell
    }
    
    public func customCellForRow<T>(at indexPath: IndexPath) -> T where T: UITableViewCell {
        let cell = cellForRow(at: indexPath)
        guard let castedCell = cellForRow(at: indexPath) as? T else {
            fatalError("Expected to dequeue cell of type \(T.self), got \(type(of: cell))")
        }
        
        return castedCell
    }
    
    public func registerConventionBrandedHeader() {
        let headerType = ConventionBrandedTableViewHeaderFooterView.self
        register(headerType, forHeaderFooterViewReuseIdentifier: headerType.identifier)
    }
    
    public func dequeueConventionBrandedHeader() -> ConventionBrandedTableViewHeaderFooterView {
        let identifier = ConventionBrandedTableViewHeaderFooterView.identifier
        let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: identifier)
        
        guard let header = headerFooterView as? ConventionBrandedTableViewHeaderFooterView else {
            fatalError("\(ConventionBrandedTableViewHeaderFooterView.self) is not registered in this table view!")
        }
        
        return header
    }
    
    public func adjustScrollIndicatorInsetsForSafeAreaCompensation() {
        if #available(iOS 11.1, *) {
            horizontalScrollIndicatorInsets.right = -safeAreaInsets.right
        }
    }
    
    public func deselectSelectedRow(animated: Bool = false) {
        if let indexPathForSelectedRow = indexPathForSelectedRow {
            deselectRow(at: indexPathForSelectedRow, animated: animated)
        }
    }

    private func abortDueToUnregisteredOrMissingCell<T>(_ type: T.Type, identifier: String) -> Never {
        fatalError("Cell registered with identifier \"\(identifier)\" not present, or not an instance of \(type)")
    }
    
}
