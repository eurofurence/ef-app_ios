import UIKit

public class CapturingViewController: UIViewController {

    public private(set) var capturedPresentedAlertViewController: UIAlertController?
    public private(set) var capturedPresentedViewController: UIViewController?
    public private(set) var animatedTransition = false
    public private(set) var capturedPresentationCompletionHandler: (() -> Void)?
    override public func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        capturedPresentedViewController = viewControllerToPresent
        capturedPresentedAlertViewController = viewControllerToPresent as? UIAlertController
        animatedTransition = flag
        capturedPresentationCompletionHandler = completion
    }

    public private(set) var didDismissPresentedController = false
    public private(set) var didDismissUsingAnimations = false
    public private(set) var capturedDismissalCompletionHandler: (() -> Void)?
    override public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        didDismissPresentedController = true
        didDismissUsingAnimations = flag
        capturedDismissalCompletionHandler = completion
    }

    public var _presentedViewController: UIViewController?
    override public var presentedViewController: UIViewController? { return _presentedViewController }

}

public class AutomaticallyCompletesOperationsViewController: CapturingViewController {
    
    override public func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        completion?()
    }
    
    override public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        completion?()
    }
    
}
