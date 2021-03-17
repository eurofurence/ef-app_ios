import ComponentBase
import Foundation

struct TutorialPresentationContext {

    var tutorialScene: TutorialScene
    var presentationAssets: PresentationAssets
    var alertRouter: AlertRouter
    var tutorialStateProviding: UserCompletedTutorialStateProviding
    var networkReachability: NetworkReachability
    var witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest

}
