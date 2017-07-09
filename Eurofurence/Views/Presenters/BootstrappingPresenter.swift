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
         tutorialItems: [TutorialPageInfo],
         routers: Routers) {
        if firstTimeLaunchProviding.userHasCompletedTutorial {
            routers.splashScreenRouter.showSplashScreen()
        } else {
            let tutorialPage = routers.tutorialRouter.showTutorial().showTutorialPage()
            guard let pageInfo = tutorialItems.first else { return }

            tutorialPage.showPageTitle(pageInfo.title)
        }
    }

}
