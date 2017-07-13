//
//  InitiateDownloadTutorialPagePresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct InitiateDownloadTutorialPagePresenter: TutorialPage,
                                              TutorialPageSceneDelegate {

    private var networkReachability: NetworkReachability
    private var splashScreenRouter: SplashScreenRouter
    private var alertRouter: AlertRouter
    private var presentationStrings: PresentationStrings
    private var tutorialStateProviding: UserCompletedTutorialStateProviding

    init(tutorialScene: TutorialScene,
         splashScreenRouter: SplashScreenRouter,
         alertRouter: AlertRouter,
         presentationAssets: PresentationAssets,
         presentationStrings: PresentationStrings,
         networkReachability: NetworkReachability,
         tutorialStateProviding: UserCompletedTutorialStateProviding) {
        self.splashScreenRouter = splashScreenRouter
        self.alertRouter = alertRouter
        self.presentationStrings = presentationStrings
        self.networkReachability = networkReachability
        self.tutorialStateProviding = tutorialStateProviding

        var tutorialPage = tutorialScene.showTutorialPage()
        tutorialPage.tutorialPageSceneDelegate = self
        tutorialPage.showPageImage(presentationAssets.initialLoadInformationAsset)
        tutorialPage.showPageTitle(presentationStrings.presentationString(for: .tutorialInitialLoadTitle))
        tutorialPage.showPageDescription(presentationStrings.presentationString(for: .tutorialInitialLoadDescription))
        tutorialPage.showPrimaryActionButton()
        tutorialPage.showPrimaryActionDescription(presentationStrings.presentationString(for: .tutorialInitialLoadBeginDownload))
    }

    func tutorialPageSceneDidTapPrimaryActionButton(_ tutorialPageScene: TutorialPageScene) {
        if networkReachability.wifiReachable {
            completeTutorial()
        } else {
            let allowDownloadMessage = presentationStrings.presentationString(for: .cellularDownloadAlertContinueOverCellularTitle)
            let allowDownloadOverCellular = AlertAction(title: allowDownloadMessage, action: completeTutorial)
            let cancel = AlertAction(title: presentationStrings.presentationString(for: .cancel))
            alertRouter.showAlert(title: presentationStrings.presentationString(for: .cellularDownloadAlertTitle),
                                  message: presentationStrings.presentationString(for: .cellularDownloadAlertMessage),
                                  actions: allowDownloadOverCellular, cancel)
        }
    }

    func tutorialPageSceneDidTapSecondaryActionButton(_ tutorialPageScene: TutorialPageScene) {
    }

    private func completeTutorial() {
        _ = splashScreenRouter.showSplashScreen()
        tutorialStateProviding.markTutorialAsComplete()
    }

}
