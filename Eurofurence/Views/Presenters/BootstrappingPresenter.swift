//
//  BootstrappingPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct BootstrappingPresenter {

    init(context: ApplicationContext, routers: Routers) {
        if context.firstTimeLaunchProviding.userHasCompletedTutorial {
            routers.splashScreenRouter.showSplashScreen()
        } else {
            let tutorialPage = routers.tutorialRouter.showTutorial().showTutorialPage()
            guard let pageInfo = context.tutorialItems.first else { return }

            tutorialPage.showPageTitle(pageInfo.title)
            tutorialPage.showPageDescription(pageInfo.description)
            tutorialPage.showPageImage(pageInfo.image)

            if let action = pageInfo.primaryAction {
                tutorialPage.showPrimaryActionButton()
                tutorialPage.showPrimaryActionDescription(action.actionDescription)
            }

            if let action = pageInfo.secondaryAction {
                tutorialPage.showSecondaryActionButton()
                tutorialPage.showSecondaryActionDescription(action.actionDescription)
            }
        }
    }

}
