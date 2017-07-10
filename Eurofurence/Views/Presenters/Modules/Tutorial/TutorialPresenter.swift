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
            _ = splashScreenRouter.showSplashScreen()
            tutorialStateProviding.markTutorialAsComplete()
        }

    }

    // MARK: Properties

    private var tutorialPage: TutorialPageScene
    private var presentationStrings: PresentationStrings
    private var presentationAssets: PresentationAssets
    private var currentPrimaryAction: TutorialPageAction?
    private var currentSecondaryAction: TutorialPageAction?
    private var splashScreenRouter: SplashScreenRouter
    private var alertRouter: AlertRouter
    private var tutorialStateProviding: UserCompletedTutorialStateProviding
    private var networkReachability: NetworkReachability

    // MARK: Initialization

    init(tutorialScene: TutorialScene,
         tutorialPages: [TutorialPageInfo],
         presentationStrings: PresentationStrings,
         presentationAssets: PresentationAssets,
         splashScreenRouter: SplashScreenRouter,
         alertRouter: AlertRouter,
         tutorialStateProviding: UserCompletedTutorialStateProviding,
         networkReachability: NetworkReachability) {
        tutorialPage = tutorialScene.showTutorialPage()
        self.presentationStrings = presentationStrings
        self.presentationAssets = presentationAssets
        self.splashScreenRouter = splashScreenRouter
        self.alertRouter = alertRouter
        self.tutorialStateProviding = tutorialStateProviding
        self.networkReachability = networkReachability

        if let pageInfo = tutorialPages.first {
            show(page: pageInfo)
        } else {
            showInitiateDownloadPage()
        }
    }

    // MARK: TutorialPageSceneDelegate

    func tutorialPageSceneDidTapPrimaryActionButton(_ tutorialPageScene: TutorialPageScene) {
        let delegate = CompleteTutorialActionDelegate(splashScreenRouter: splashScreenRouter, tutorialStateProviding: tutorialStateProviding)
        currentPrimaryAction?.runAction(delegate)

        if networkReachability.wifiReachable {
            _ = splashScreenRouter.showSplashScreen()
        } else {
            alertRouter.showAlert()
        }
    }

    func tutorialPageSceneDidTapSecondaryActionButton(_ tutorialPageScene: TutorialPageScene) {
        let delegate = CompleteTutorialActionDelegate(splashScreenRouter: splashScreenRouter, tutorialStateProviding: tutorialStateProviding)
        currentSecondaryAction?.runAction(delegate)
    }

    // MARK: Private

    private func show(page pageInfo: TutorialPageInfo) {
        tutorialPage.tutorialPageSceneDelegate = self
        tutorialPage.showPageTitle(presentationStrings.presentationString(for: .tutorialInitialLoadTitle))
        tutorialPage.showPageDescription(presentationStrings.presentationString(for: .tutorialInitialLoadDescription))
        tutorialPage.showPageImage(pageInfo.image)

        if let action = pageInfo.primaryAction {
            currentPrimaryAction = action
            tutorialPage.showPrimaryActionButton()
            tutorialPage.showPrimaryActionDescription(presentationStrings.presentationString(for: .tutorialInitialLoadBeginDownload))
        }

        if let action = pageInfo.secondaryAction {
            currentSecondaryAction = action
            tutorialPage.showSecondaryActionButton()
            tutorialPage.showSecondaryActionDescription(action.actionDescription)
        }
    }

    private func string(for scenario: PresentationScenario) -> String {
        return presentationStrings.presentationString(for: scenario)
    }

    private func showInitiateDownloadPage() {
        tutorialPage.tutorialPageSceneDelegate = self
        tutorialPage.showPageImage(presentationAssets.initialLoadInformationAsset)
        tutorialPage.showPageTitle(string(for: .tutorialInitialLoadTitle))
        tutorialPage.showPageDescription(string(for: .tutorialInitialLoadDescription))
        tutorialPage.showPrimaryActionButton()
        tutorialPage.showPrimaryActionDescription(string(for: .tutorialInitialLoadBeginDownload))
    }

}
