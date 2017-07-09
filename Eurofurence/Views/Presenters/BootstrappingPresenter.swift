//
//  BootstrappingPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class BootstrappingPresenter: TutorialPageSceneDelegate {

    var currentPrimaryAction: TutorialPageAction?
    var currentSecondaryAction: TutorialPageAction?

    init(context: ApplicationContext, routers: Routers) {
        if context.firstTimeLaunchProviding.userHasCompletedTutorial {
            routers.splashScreenRouter.showSplashScreen()
        } else {
            var tutorialPage = routers.tutorialRouter.showTutorial().showTutorialPage()
            guard let pageInfo = context.tutorialItems.first else { return }

            tutorialPage.tutorialPageSceneDelegate = self
            tutorialPage.showPageTitle(pageInfo.title)
            tutorialPage.showPageDescription(pageInfo.description)
            tutorialPage.showPageImage(pageInfo.image)

            if let action = pageInfo.primaryAction {
                currentPrimaryAction = action
                tutorialPage.showPrimaryActionButton()
                tutorialPage.showPrimaryActionDescription(action.actionDescription)
            }

            if let action = pageInfo.secondaryAction {
                currentSecondaryAction = action
                tutorialPage.showSecondaryActionButton()
                tutorialPage.showSecondaryActionDescription(action.actionDescription)
            }
        }
    }

    func tutorialPageSceneDidTapPrimaryActionButton(_ tutorialPageScene: TutorialPageScene) {
        currentPrimaryAction?.runAction()
    }

    func tutorialPageSceneDidTapSecondaryActionButton(_ tutorialPageScene: TutorialPageScene) {
        currentSecondaryAction?.runAction()
    }

}
