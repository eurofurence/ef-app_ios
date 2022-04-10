import UIKit

extension UIView {
    
    func viewWithAccessibilityIdentifier<T>(_ accessibilityIdentifier: String) -> T? where T: UIView {
        if self.accessibilityIdentifier == accessibilityIdentifier, let view = self as? T {
            return view
        } else {
            return subviews
                .lazy
                .compactMap({ $0.viewWithAccessibilityIdentifier(accessibilityIdentifier) as? T })
                .first
        }
    }
    
}
