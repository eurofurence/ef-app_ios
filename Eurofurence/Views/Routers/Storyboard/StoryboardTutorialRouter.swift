//
//  StoryboardTutorialRouter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

struct StoryboardTutorialRouter: TutorialRouter {

    var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func showTutorial() -> TutorialScene {
        let storyboardBundle = Bundle(for: TutorialViewController.self)
        let storyboard = UIStoryboard(name: "Tutorial", bundle: storyboardBundle)
        guard let tutorialController = storyboard.instantiateInitialViewController() as? TutorialViewController else {
            fatalError("Expected initial view controller of Tutorial storyboard to be instance of \(TutorialViewController.self)")
        }

        window.rootViewController = tutorialController

        return tutorialController
    }

}
