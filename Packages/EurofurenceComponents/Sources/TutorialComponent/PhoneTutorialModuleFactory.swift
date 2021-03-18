import ComponentBase
import Foundation
import UIKit

public protocol TutorialComponentDelegate {

    func tutorialModuleDidFinishPresentingTutorial()

}

struct TutorialModule: TutorialComponentFactory {

    var tutorialSceneFactory: TutorialSceneFactory
    var presentationAssets: PresentationAssets
    var alertRouter: AlertRouter
    var tutorialStateProviding: UserCompletedTutorialStateProviding
    var networkReachability: NetworkReachability
    var witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest

    func makeTutorialModule(_ delegate: TutorialComponentDelegate) -> UIViewController {
        let tutorialScene = tutorialSceneFactory.makeTutorialScene()
        let tutorialContext = TutorialPresentationContext(
            tutorialScene: tutorialScene,
            presentationAssets: presentationAssets,
            alertRouter: alertRouter,
            tutorialStateProviding: tutorialStateProviding,
            networkReachability: networkReachability,
            witnessedTutorialPushPermissionsRequest: witnessedTutorialPushPermissionsRequest)

        _ = TutorialPresenter(delegate: delegate, context: tutorialContext)

        return tutorialScene
    }

}
