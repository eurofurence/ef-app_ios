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

    private var delegate: TutorialPageDelegate
    private var networkReachability: NetworkReachability
    private var alertRouter: AlertRouter
    private var presentationStrings: PresentationStrings

    init(delegate: TutorialPageDelegate,
         tutorialScene: TutorialScene,
         alertRouter: AlertRouter,
         presentationAssets: PresentationAssets,
         presentationStrings: PresentationStrings,
         networkReachability: NetworkReachability) {
        self.delegate = delegate
        self.alertRouter = alertRouter
        self.presentationStrings = presentationStrings
        self.networkReachability = networkReachability

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
            delegate.tutorialPageCompletedByUser(self)
        } else {
            let allowDownloadMessage = presentationStrings.presentationString(for: .cellularDownloadAlertContinueOverCellularTitle)
            let allowDownloadOverCellular = AlertAction(title: allowDownloadMessage, action: {
                self.delegate.tutorialPageCompletedByUser(self)
            })
            let cancel = AlertAction(title: presentationStrings.presentationString(for: .cancel))
            alertRouter.showAlert(title: presentationStrings.presentationString(for: .cellularDownloadAlertTitle),
                                  message: presentationStrings.presentationString(for: .cellularDownloadAlertMessage),
                                  actions: allowDownloadOverCellular, cancel)
        }
    }

    func tutorialPageSceneDidTapSecondaryActionButton(_ tutorialPageScene: TutorialPageScene) {
    }

}
