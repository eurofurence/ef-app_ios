import UIKit.UIStoryboard
import UIKit.UIViewController

extension UIStoryboard {

    public func instantiate<T>(_ viewControllerType: T.Type) -> T where T: UIViewController {
        let identifier = String(describing: T.self)
        guard let viewController = instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Unable to instantiate view controller \(T.self) using its name")
        }

        return viewController
    }

}
