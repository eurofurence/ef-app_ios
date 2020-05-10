import UIKit

class TutorialViewController: UIPageViewController, TutorialScene {

    // MARK: Overrides

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: TutorialScene

    func showTutorialPage() -> TutorialPageScene {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "TutorialPageViewController")
        guard let tutorialController = viewController as? TutorialPageViewController else {
            fatalError("Unable to resolve \(TutorialPageViewController.self) from Storyboard")
        }

        setViewControllers([tutorialController], direction: .forward, animated: true)

        return tutorialController
    }

}
