//
//  PhonePreloadSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

struct PhonePreloadSceneFactory: PreloadSceneFactory {

    typealias Scene = SplashViewController

    func makePreloadScene() -> SplashViewController {
        let storyboardBundle = Bundle(for: SplashViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: storyboardBundle)
        guard let root = storyboard.instantiateInitialViewController() as? UINavigationController else {
            fatalError("Unexpected entry point into Main storyboard")
        }

        guard let splash = root.topViewController as? SplashViewController else {
            fatalError("Expected \(SplashViewController.self) as root of UINavigationController")
        }

        return splash
    }

}
