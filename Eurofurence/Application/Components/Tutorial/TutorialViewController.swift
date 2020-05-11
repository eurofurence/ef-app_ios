import UIKit

public class TutorialViewController: UIPageViewController, TutorialScene {

    // MARK: Overrides

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: TutorialScene

    public func showTutorialPage() -> TutorialPageScene {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "TutorialPageViewController")
        guard let tutorialController = viewController as? TutorialPageViewController else {
            fatalError("Unable to resolve \(TutorialPageViewController.self) from Storyboard")
        }

        setViewControllers([tutorialController], direction: .forward, animated: true)

        return tutorialController
    }

}
