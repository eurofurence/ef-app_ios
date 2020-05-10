import EurofurenceModel
import Foundation
import UIKit.UIViewController

struct EventDetailComponentFactoryImpl: EventDetailComponentFactory {

    var sceneFactory: EventDetailSceneFactory
    var interactor: EventDetailViewModelFactory
    var hapticEngine: SelectionChangedHaptic
    var interactionRecorder: EventInteractionRecorder

    func makeEventDetailComponent(for event: EventIdentifier, delegate: EventDetailComponentDelegate) -> UIViewController {
        let scene = sceneFactory.makeEventDetailScene()
        _ = EventDetailPresenter(
            scene: scene,
            interactor: interactor,
            hapticEngine: hapticEngine,
            event: event,
            delegate: delegate,
            interactionRecorder: interactionRecorder
        )

        return scene
    }

}
