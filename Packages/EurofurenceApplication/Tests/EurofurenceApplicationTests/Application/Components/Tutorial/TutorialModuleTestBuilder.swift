import EurofurenceApplication
import EurofurenceModel
import UIKit.UIViewController
import XCTEurofurenceModel

class TutorialModuleTestBuilder {

    struct Context {
        var tutorialViewController: UIViewController
        var tutorialSceneFactory: StubTutorialSceneFactory
        var delegate: CapturingTutorialComponentDelegate
        var tutorial: CapturingTutorialScene
        var page: CapturingTutorialPageScene
        var assets: PresentationAssets
        var alertRouter: CapturingAlertRouter
        var tutorialStateProviding: StubFirstTimeLaunchStateProvider
    }

    let alertRouter = CapturingAlertRouter()
    let stateProviding = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
    let presentationAssets = StubPresentationAssets()
    let tutorialSceneFactory = StubTutorialSceneFactory()
    let delegate = CapturingTutorialComponentDelegate()
    var networkReachability: NetworkReachability = WiFiNetwork()
    var pushPermissionsRequestState: WitnessedTutorialPushPermissionsRequest = UserNotAcknowledgedPushPermissions()

    @discardableResult
    func with(_ networkReachability: NetworkReachability) -> TutorialModuleTestBuilder {
        self.networkReachability = networkReachability
        return self
    }

    @discardableResult
    func with(
        _ pushPermissionsRequestStateProviding: WitnessedTutorialPushPermissionsRequest
    ) -> TutorialModuleTestBuilder {
        self.pushPermissionsRequestState = pushPermissionsRequestStateProviding
        return self
    }

    func build() -> TutorialModuleTestBuilder.Context {
        let vc = TutorialModuleBuilder(alertRouter: alertRouter)
            .with(tutorialSceneFactory)
            .with(presentationAssets)
            .with(stateProviding)
            .with(networkReachability)
            .with(pushPermissionsRequestState)
            .build()
            .makeTutorialModule(delegate)

        return Context(tutorialViewController: vc,
                       tutorialSceneFactory: tutorialSceneFactory,
                       delegate: delegate,
                       tutorial: tutorialSceneFactory.tutorialScene,
                       page: tutorialSceneFactory.tutorialScene.tutorialPage,
                       assets: presentationAssets,
                       alertRouter: alertRouter,
                       tutorialStateProviding: stateProviding)
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
