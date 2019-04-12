import UIKit

extension UITableView {

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

    private func abortDueToUnregisteredOrMissingCell<T>(_ type: T.Type, identifier: String) -> Never {
        fatalError("Cell registered with identifier \"\(identifier)\" not present, or not an instance of \(type)")
    }

}
