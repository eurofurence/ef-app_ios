//
//  RequestPushPermissionsTutorialPagePresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

struct RequestPushPermissionsTutorialPagePresenter: TutorialPage,
TutorialPageSceneDelegate {

    private var delegate: TutorialPageDelegate
    private var presentationStrings: PresentationStrings
    private var presentationAssets: PresentationAssets
    private var witnessedSystemPushPermissionsRequest: WitnessedSystemPushPermissionsRequest
    private var witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest
    private var pushPermissionsRequesting: PushPermissionsRequesting

    init(delegate: TutorialPageDelegate,
         tutorialScene: TutorialScene,
         presentationStrings: PresentationStrings,
         presentationAssets: PresentationAssets,
         witnessedSystemPushPermissionsRequest: WitnessedSystemPushPermissionsRequest,
         witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest,
         pushPermissionsRequesting: PushPermissionsRequesting) {
        self.delegate = delegate
        self.presentationStrings = presentationStrings
        self.presentationAssets = presentationAssets
        self.witnessedSystemPushPermissionsRequest = witnessedSystemPushPermissionsRequest
        self.witnessedTutorialPushPermissionsRequest = witnessedTutorialPushPermissionsRequest
        self.pushPermissionsRequesting = pushPermissionsRequesting

        var tutorialPage = tutorialScene.showTutorialPage()
        tutorialPage.tutorialPageSceneDelegate = self
        tutorialPage.showPageTitle(presentationStrings.presentationString(for: .tutorialPushPermissionsRequestTitle))
        tutorialPage.showPageDescription(presentationStrings.presentationString(for: .tutorialPushPermissionsRequestDescription))
        tutorialPage.showPageImage(presentationAssets.requestPushNotificationPermissionsAsset)
        tutorialPage.showPrimaryActionButton()
        tutorialPage.showPrimaryActionDescription(presentationStrings.presentationString(for: .tutorialAllowPushPermissions))
        tutorialPage.showSecondaryActionButton()
        tutorialPage.showSecondaryActionDescription(presentationStrings.presentationString(for: .tutorialDenyPushPermissions))
    }

    func tutorialPageSceneDidTapPrimaryActionButton(_ tutorialPageScene: TutorialPageScene) {
        witnessedSystemPushPermissionsRequest.markWitnessedSystemPushPermissionsRequest()
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
