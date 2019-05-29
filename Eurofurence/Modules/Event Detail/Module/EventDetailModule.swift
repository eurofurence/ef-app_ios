import EurofurenceModel
import Foundation
import UIKit.UIViewController

struct EventDetailModule: EventDetailModuleProviding {

    var sceneFactory: EventDetailSceneFactory
    var interactor: EventDetailInteractor
    var hapticEngine: SelectionChangedHaptic
    var interactionRecorder: EventInteractionRecorder

    func makeEventDetailModule(for event: EventIdentifier, delegate: EventDetailModuleDelegate) -> UIViewController {
        let scene = sceneFactory.makeEventDetailScene()
        _ = EventDetailPresenter(scene: scene,
                                 interactor: interactor,
                                 hapticEngine: hapticEngine,
                                 event: event,
                                 delegate: delegate,
                                 interactionRecorder: interactionRecorder)

        return scene
    }

}
