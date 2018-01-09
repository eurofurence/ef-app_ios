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

    init(delegate: TutorialPageDelegate,
         tutorialScene: TutorialScene,
         alertRouter: AlertRouter,
         presentationAssets: PresentationAssets,
         networkReachability: NetworkReachability) {
        self.delegate = delegate
        self.alertRouter = alertRouter
        self.networkReachability = networkReachability

        var tutorialPage = tutorialScene.showTutorialPage()
        tutorialPage.tutorialPageSceneDelegate = self
        tutorialPage.showPageImage(presentationAssets.initialLoadInformationAsset)
        tutorialPage.showPageTitle(LocalizedStrings.tutorialInitialLoadTitle)
        tutorialPage.showPageDescription(LocalizedStrings.tutorialInitialLoadDescription)
        tutorialPage.showPrimaryActionButton()
        tutorialPage.showPrimaryActionDescription(LocalizedStrings.tutorialInitialLoadBeginDownload)
    }

    func tutorialPageSceneDidTapPrimaryActionButton(_ tutorialPageScene: TutorialPageScene) {
        if networkReachability.wifiReachable {
            delegate.tutorialPageCompletedByUser(self)
        } else {
            let allowDownloadMessage = LocalizedStrings.cellularDownloadAlertContinueOverCellularTitle
            let allowDownloadOverCellular = AlertAction(title: allowDownloadMessage, action: {
                self.delegate.tutorialPageCompletedByUser(self)
            })
            let cancel = AlertAction(title: LocalizedStrings.cancel)

            let alert = Alert(title: LocalizedStrings.cellularDownloadAlertTitle,
                              message: LocalizedStrings.cellularDownloadAlertMessage,
                              actions: [allowDownloadOverCellular, cancel])
            alertRouter.show(alert)
        }
    }

    func tutorialPageSceneDidTapSecondaryActionButton(_ tutorialPageScene: TutorialPageScene) {
    }

}
