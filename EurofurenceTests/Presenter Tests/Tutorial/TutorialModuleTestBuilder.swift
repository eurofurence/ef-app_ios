//
//  TutorialModuleTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class TutorialModuleTestBuilder {
    
    struct Context {
        var tutorialViewController: UIViewController
        var tutorialSceneFactory: StubTutorialSceneFactory
        var delegate: CapturingTutorialModuleDelegate
        var tutorial: CapturingTutorialScene
        var page: CapturingTutorialPageScene
        var assets: PresentationAssets
        var alertRouter: CapturingAlertRouter
        var tutorialStateProviding: StubFirstTimeLaunchStateProvider
        var pushRequesting: CapturingPushPermissionsRequesting
    }
    
    let alertRouter = CapturingAlertRouter()
    let stateProviding = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
    let pushRequesting = CapturingPushPermissionsRequesting()
    let presentationAssets = StubPresentationAssets()
    let tutorialSceneFactory = StubTutorialSceneFactory()
    let delegate = CapturingTutorialModuleDelegate()
    var networkReachability: NetworkReachability = ReachableWiFiNetwork()
    var pushPermissionsRequestStateProviding: WitnessedTutorialPushPermissionsRequest = UserNotAcknowledgedPushPermissions()
    
    @discardableResult
    func with(_ networkReachability: NetworkReachability) -> TutorialModuleTestBuilder {
        self.networkReachability = networkReachability
        return self
    }
    
    @discardableResult
    func with(_ pushPermissionsRequestStateProviding: WitnessedTutorialPushPermissionsRequest) -> TutorialModuleTestBuilder {
        self.pushPermissionsRequestStateProviding = pushPermissionsRequestStateProviding
        return self
    }
    
    func build() -> TutorialModuleTestBuilder.Context {
        let vc = TutorialModuleBuilder()
            .with(tutorialSceneFactory)
            .with(presentationAssets)
            .with(alertRouter)
            .with(stateProviding)
            .with(networkReachability)
            .with(pushRequesting)
            .with(pushPermissionsRequestStateProviding)
            .build()
            .makeTutorialModule(delegate)
        
        return Context(tutorialViewController: vc,
                       tutorialSceneFactory: tutorialSceneFactory,
                       delegate: delegate,
                       tutorial: tutorialSceneFactory.tutorialScene,
                       page: tutorialSceneFactory.tutorialScene.tutorialPage,
                       assets: presentationAssets,
                       alertRouter: alertRouter,
                       tutorialStateProviding: stateProviding,
                       pushRequesting: pushRequesting)
    }
    
}

extension TutorialModuleTestBuilder.Context {
    
    func tapPrimaryButton() {
        tutorial.tutorialPage.simulateTappingPrimaryActionButton()
    }
    
    func tapSecondaryButton() {
        tutorial.tutorialPage.simulateTappingSecondaryActionButton()
    }
    
}
