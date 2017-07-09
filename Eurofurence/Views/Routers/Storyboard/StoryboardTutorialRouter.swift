//
//  StoryboardTutorialRouter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

struct StoryboardTutorialRouter: TutorialRouter {

    var animator: RootViewControllerAnimator

    init(animator: RootViewControllerAnimator) {
        self.animator = animator
    }

    func showTutorial() -> TutorialScene {
        let storyboardBundle = Bundle(for: TutorialViewController.self)
        let storyboard = UIStoryboard(name: "Tutorial", bundle: storyboardBundle)
        guard let tutorialController = storyboard.instantiateInitialViewController() as? TutorialViewController else {
            fatalError("Expected initial view controller of Tutorial storyboard to be instance of \(TutorialViewController.self)")
        }

        animator.animateTransition(to: tutorialController)

        return tutorialController
    }

}
