//
//  RequestPushPermissionsTutorialPagePresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

struct RequestPushPermissionsTutorialPagePresenter: TutorialPage, TutorialPageSceneDelegate {

    private var delegate: TutorialPageDelegate
    private var presentationAssets: PresentationAssets
    private var witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest
    private var pushPermissionsRequesting: PushPermissionsRequesting

    init(delegate: TutorialPageDelegate,
         tutorialScene: TutorialScene,
         presentationAssets: PresentationAssets,
         witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest,
         pushPermissionsRequesting: PushPermissionsRequesting) {
        self.delegate = delegate
        self.presentationAssets = presentationAssets
        self.witnessedTutorialPushPermissionsRequest = witnessedTutorialPushPermissionsRequest
        self.pushPermissionsRequesting = pushPermissionsRequesting

        var tutorialPage = tutorialScene.showTutorialPage()
        tutorialPage.tutorialPageSceneDelegate = self
        tutorialPage.showPageTitle(LocalizedStrings.tutorialPushPermissionsRequestTitle)
        tutorialPage.showPageDescription(LocalizedStrings.tutorialPushPermissionsRequestDescription)
        tutorialPage.showPageImage(presentationAssets.requestPushNotificationPermissionsAsset)
        tutorialPage.showPrimaryActionButton()
        tutorialPage.showPrimaryActionDescription(LocalizedStrings.tutorialAllowPushPermissions)
        tutorialPage.showSecondaryActionButton()
        tutorialPage.showSecondaryActionDescription(LocalizedStrings.tutorialDenyPushPermissions)
    }

    func tutorialPageSceneDidTapPrimaryActionButton(_ tutorialPageScene: TutorialPageScene) {
        pushPermissionsRequesting.requestPushPermissions {
            self.witnessedTutorialPushPermissionsRequest.markWitnessedTutorialPushPermissionsRequest()
            self.delegate.tutorialPageCompletedByUser(self)
        }
    }

    func tutorialPageSceneDidTapSecondaryActionButton(_ tutorialPageScene: TutorialPageScene) {
        witnessedTutorialPushPermissionsRequest.markWitnessedTutorialPushPermissionsRequest()
        delegate.tutorialPageCompletedByUser(self)
    }

}
