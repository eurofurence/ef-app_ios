import UIKit

class HideNavigationBarShadowForSpecificViewControllerDelegate: NSObject, UINavigationControllerDelegate {

    private let viewController: UIViewController

    init(viewControllerToHideNavigationBarShadow viewController: UIViewController) {
        self.viewController = viewController
    }

    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        updateNavigationBarShadow(viewController, navigationController)
    }

    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        updateNavigationBarShadow(viewController, navigationController)
    }

    private func updateNavigationBarShadow(
        _ presentedViewController: UIViewController,
        _ navigationController: UINavigationController
    ) {
        if presentedViewController == self.viewController {
            navigationController.navigationBar.shadowImage = UIImage(named: "Transparent Pixel")
        } else {
            navigationController.navigationBar.shadowImage = nil
        }
    }

}
