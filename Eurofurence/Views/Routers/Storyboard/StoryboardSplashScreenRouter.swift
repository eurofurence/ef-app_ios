//
//  StoryboardSplashScreenRouter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

struct StoryboardSplashScreenRouter: SplashScreenRouter {

    var animator: RootViewControllerAnimator

    func showSplashScreen() -> SplashScene {
        let storyboardBundle = Bundle(for: SplashViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: storyboardBundle)
        guard let root = storyboard.instantiateInitialViewController() as? UINavigationController else {
            fatalError("Unexpected entry point into Main storyboard")
        }

        guard let splash = root.topViewController as? SplashViewController else {
            fatalError("Expected \(SplashViewController.self) as root of UINavigationController")
        }

        splash.loadViewIfNeeded()
        animator.animateTransition(to: root)

        return splash
    }

}
