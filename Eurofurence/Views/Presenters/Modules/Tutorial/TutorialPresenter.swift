//
//  TutorialPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class TutorialPresenter: TutorialPageSceneDelegate {

    // MARK: Properties

    private var tutorialScene: TutorialScene
    private var presentationStrings: PresentationStrings
    private var presentationAssets: PresentationAssets
    private var splashScreenRouter: SplashScreenRouter
    private var alertRouter: AlertRouter
    private var tutorialStateProviding: UserCompletedTutorialStateProviding
    private var networkReachability: NetworkReachability

    // MARK: Initialization

    init(tutorialScene: TutorialScene,
         presentationStrings: PresentationStrings,
         presentationAssets: PresentationAssets,
         splashScreenRouter: SplashScreenRouter,
         alertRouter: AlertRouter,
         tutorialStateProviding: UserCompletedTutorialStateProviding,
         networkReachability: NetworkReachability) {
        self.tutorialScene = tutorialScene
        self.presentationStrings = presentationStrings
        self.presentationAssets = presentationAssets
        self.splashScreenRouter = splashScreenRouter
        self.alertRouter = alertRouter
        self.tutorialStateProviding = tutorialStateProviding
        self.networkReachability = networkReachability

        showInitiateDownloadPage()
    }

    // MARK: TutorialPageSceneDelegate

    func tutorialPageSceneDidTapPrimaryActionButton(_ tutorialPageScene: TutorialPageScene) {
        if networkReachability.wifiReachable {
            _ = splashScreenRouter.showSplashScreen()
        } else {
            let allowDownloadMessage = string(for: .cellularDownloadAlertContinueOverCellularTitle)
            let allowDownloadOverCellular = AlertAction(title: allowDownloadMessage) {
                _ = self.splashScreenRouter.showSplashScreen()
            }

            let cancel = AlertAction(title: string(for: .cancel))
            alertRouter.showAlert(title: string(for: .cellularDownloadAlertTitle),
                                  message: string(for: .cellularDownloadAlertMessage),
                                  actions: allowDownloadOverCellular, cancel)
        }
    }

    func tutorialPageSceneDidTapSecondaryActionButton(_ tutorialPageScene: TutorialPageScene) { }

    // MARK: Private

    private func string(for scenario: PresentationScenario) -> String {
        return presentationStrings.presentationString(for: scenario)
    }

    private func showInitiateDownloadPage() {
        var tutorialPage = tutorialScene.showTutorialPage()
        tutorialPage.tutorialPageSceneDelegate = self
        tutorialPage.showPageImage(presentationAssets.initialLoadInformationAsset)
        tutorialPage.showPageTitle(string(for: .tutorialInitialLoadTitle))
        tutorialPage.showPageDescription(string(for: .tutorialInitialLoadDescription))
        tutorialPage.showPrimaryActionButton()
        tutorialPage.showPrimaryActionDescription(string(for: .tutorialInitialLoadBeginDownload))
    }

}
