//
//  BootstrappingPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct BootstrappingPresenter {

    init(firstTimeLaunchProviding: UserCompletedTutorialStateProviding,
         tutorialRouter: TutorialRouter,
         splashScreenRouter: SplashScreenRouter) {
        if firstTimeLaunchProviding.userHasCompletedTutorial {
            splashScreenRouter.showSplashScreen()
        } else {
            tutorialRouter.showTutorial()
        }
    }

}
