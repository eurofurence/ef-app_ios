//
//  StoryboardSplashScreenRouter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

struct StoryboardSplashScreenRouter: SplashScreenRouter {

    var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func showSplashScreen() {
        let storyboardBundle = Bundle(for: SplashViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: storyboardBundle)
        window.rootViewController = storyboard.instantiateInitialViewController()
    }

}
