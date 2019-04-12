import UIKit.UIViewAnimating

class ViewControllerDissolveTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.33
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let from = transitionContext.viewController(forKey: .from)!
        let to = transitionContext.viewController(forKey: .to)!
        let container = transitionContext.containerView

        to.view.alpha = 0
        container.addSubview(to.view)

        let animations: () -> Void = {
            to.view.alpha = 1
            from.view.alpha = 1
        }

        let finished = transitionContext.completeTransition

        if transitionContext.isAnimated {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: animations, completion: finished)
        } else {
            animations()
            finished(true)
        }
    }

}
