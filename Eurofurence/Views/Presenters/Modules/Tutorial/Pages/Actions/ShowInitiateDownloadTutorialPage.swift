//
//  ShowInitiateDownloadTutorialPage.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

struct ShowInitiateDownloadTutorialPage: TutorialPageDelegate {

    var tutorialScene: TutorialScene
    var splashScreenRouter: SplashScreenRouter
    var alertRouter: AlertRouter
    var presentationAssets: PresentationAssets
    var presentationStrings: PresentationStrings
    var networkReachability: NetworkReachability
    var tutorialStateProviding: UserCompletedTutorialStateProviding

    func tutorialPageCompletedByUser(_ tutorialPage: TutorialPage) {
        let completeTutorial = CompleteTutorial(splashScreenRouter: splashScreenRouter,
                                                tutorialStateProviding: tutorialStateProviding)
        _ = InitiateDownloadTutorialPagePresenter(delegate: completeTutorial,
                                                  tutorialScene: tutorialScene,
                                                  alertRouter: alertRouter,
                                                  presentationAssets: presentationAssets,
                                                  presentationStrings: presentationStrings,
                                                  networkReachability: networkReachability)
    }

}
