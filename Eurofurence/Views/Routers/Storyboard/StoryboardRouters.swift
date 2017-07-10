//
//  StoryboardRouters.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

struct DummyAlertRouter: AlertRouter {
    func showAlert() {

    }
}

struct StoryboardRouters: Routers {

    init(window: UIWindow) {
        let animator = RootViewControllerAnimator(window: window)
        tutorialRouter = StoryboardTutorialRouter(animator: animator)
        splashScreenRouter = StoryboardSplashScreenRouter(animator: animator)
        alertRouter = DummyAlertRouter()
    }

    var tutorialRouter: TutorialRouter
    var splashScreenRouter: SplashScreenRouter
    var alertRouter: AlertRouter

}
