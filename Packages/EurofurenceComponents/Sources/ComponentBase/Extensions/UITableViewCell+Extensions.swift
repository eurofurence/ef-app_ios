import UIKit

extension UITableViewCell {
    
    public func hideSeperator() {
#if !targetEnvironment(macCatalyst)
        separatorInset = UIEdgeInsets(top: 0, left: .greatestFiniteMagnitude, bottom: 0, right: 0)
#endif
    }
    
    @objc open dynamic class func registerNib(in tableView: UITableView) {
        fatalError("\(String(describing: Self.self)) should implement \(#function) to enable convenience registration")
    }
    
    public class func registerNib(in tableView: UITableView, bundle: Bundle) {
        let cellName = String(describing: Self.self)
        let nib = UINib(nibName: cellName, bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: cellName)
    }
    
}
