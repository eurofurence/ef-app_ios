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

    func showTutorial() {
        let storyboardBundle = Bundle(for: TutorialViewController.self)
        let storyboard = UIStoryboard(name: "Tutorial", bundle: storyboardBundle)
        window.rootViewController = storyboard.instantiateInitialViewController()
    }

}
