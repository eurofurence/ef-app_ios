import UIKit.UINavigationController

class CapturingNavigationController: UINavigationController {

    private(set) var pushedViewControllers = [UIViewController]()
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewControllers.append(viewController)
        super.pushViewController(viewController, animated: animated)
    }

    private(set) var viewControllerPoppedTo: UIViewController?
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        viewControllerPoppedTo = viewController
        return super.popToViewController(viewController, animated: animated)
    }
    
    private(set) var capturedPresentedViewController: UIViewController?
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        capturedPresentedViewController = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

}

extension CapturingNavigationController {

    func contains(_ viewController: UIViewController) -> Bool {
        return viewControllers.contains(viewController)
    }

}
