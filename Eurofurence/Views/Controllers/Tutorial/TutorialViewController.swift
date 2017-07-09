//
//  TutorialViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class TutorialViewController: UIPageViewController, TutorialScene {

    // MARK: Overrides

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        let action = TutorialBlockAction(block: temporaryWorkaroundIntoAppUntilTutorialIsFinished)
        let beginDownloadAction = TutorialPageAction(actionDescription: "Let's Go",
                                                     action: action)
        let beginDownloadItem = TutorialPageInfo(image: nil,
                                                 title: "Hello!",
                                                 description: "This is a work in progress, hit the button below to skip this for now.",
                                                 primaryAction: beginDownloadAction)

        let viewController = storyboard?.instantiateViewController(withIdentifier: "TutorialPageViewController") as! TutorialPageViewController
        viewController.view.frame = view.bounds
        viewController.pageInfo = beginDownloadItem
        setViewControllers([viewController], direction: .forward, animated: false)
    }

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

    // MARK: Private

    private func temporaryWorkaroundIntoAppUntilTutorialIsFinished() {
        let finishedTutorialAccessor = UserDefaultsTutorialStateProvider(userDefaults: .standard)
        finishedTutorialAccessor.markTutorialAsComplete()
        let delegate = UIApplication.shared.delegate!
        let window = delegate.window!!

        StoryboardSplashScreenRouter(window: window).showSplashScreen()
    }

}
