#if canImport(UIKit)
import UIKit

extension UIViewController {
    
    /// Locates the first descendant view controller of the reciver of a specific type.
    /// - Parameter type: The type of `UIViewController` to locate.
    /// - Returns: The receiver if it is an instance of `type`, otherwise the first child view controller within the
    ///            tree if it is an instance of `type`. Otherwise, `nil`.
    public func firstDescendent<T>(ofType type: T.Type) -> T? where T: UIViewController {
        if let target = self as? T {
            return target
        }
        
        for child in children {
            if let target = child as? T {
                return target
            } else {
                if let target = child.firstDescendent(ofType: type) {
                    return target
                }
            }
        }
        
        return nil
    }
    
}
#endif
