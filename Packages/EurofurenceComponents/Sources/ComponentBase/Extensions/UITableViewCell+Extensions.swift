import UIKit

extension UITableViewCell {
    
    public func hideSeperator() {
#if !targetEnvironment(macCatalyst)
        separatorInset = UIEdgeInsets(top: 0, left: .greatestFiniteMagnitude, bottom: 0, right: 0)
#endif
    }
    
}
