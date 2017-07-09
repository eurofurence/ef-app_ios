//
//  TutorialPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class TutorialPresenter: TutorialPageSceneDelegate {

    // MARK: Nested Types

    struct CompleteTutorialActionDelegate: TutorialActionDelegate {

        var splashScreenRouter: SplashScreenRouter
        var tutorialStateProviding: UserCompletedTutorialStateProviding

        func tutorialActionDidFinish(_ action: TutorialAction) {
            splashScreenRouter.showSplashScreen()
            tutorialStateProviding.markTutorialAsComplete()
        }

    }

    // MARK: Properties

    private var tutorialPage: TutorialPageScene
    private var currentPrimaryAction: TutorialPageAction?
    private var currentSecondaryAction: TutorialPageAction?
    private var splashScreenRouter: SplashScreenRouter
    private var tutorialStateProviding: UserCompletedTutorialStateProviding

    // MARK: Initialization

    init(tutorialScene: TutorialScene,
         tutorialPages: [TutorialPageInfo],
         splashScreenRouter: SplashScreenRouter,
         tutorialStateProviding: UserCompletedTutorialStateProviding) {
        tutorialPage = tutorialScene.showTutorialPage()
        self.splashScreenRouter = splashScreenRouter
        self.tutorialStateProviding = tutorialStateProviding

        if let pageInfo = tutorialPages.first {
            show(page: pageInfo)
        }
    }

    // MARK: TutorialPageSceneDelegate

    func tutorialPageSceneDidTapPrimaryActionButton(_ tutorialPageScene: TutorialPageScene) {
        let delegate = CompleteTutorialActionDelegate(splashScreenRouter: splashScreenRouter, tutorialStateProviding: tutorialStateProviding)
        currentPrimaryAction?.runAction(delegate)
    }

    func tutorialPageSceneDidTapSecondaryActionButton(_ tutorialPageScene: TutorialPageScene) {
        let delegate = CompleteTutorialActionDelegate(splashScreenRouter: splashScreenRouter, tutorialStateProviding: tutorialStateProviding)
        currentSecondaryAction?.runAction(delegate)
    }

    // MARK: Private

    private func show(page pageInfo: TutorialPageInfo) {
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
