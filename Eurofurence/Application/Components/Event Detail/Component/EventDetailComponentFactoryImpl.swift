import EurofurenceModel
import Foundation
import UIKit.UIViewController

struct EventDetailComponentFactoryImpl: EventDetailComponentFactory {

    var sceneFactory: EventDetailSceneFactory
    var eventDetailViewModelFactory: EventDetailViewModelFactory
    var hapticEngine: SelectionChangedHaptic
    var interactionRecorder: EventInteractionRecorder

    func makeEventDetailComponent(for event: EventIdentifier, delegate: EventDetailComponentDelegate) -> UIViewController {
        let scene = sceneFactory.makeEventDetailScene()
        _ = EventDetailPresenter(
            scene: scene,
            eventDetailViewModelFactory: eventDetailViewModelFactory,
            hapticEngine: hapticEngine,
            event: event,
            delegate: delegate,
            interactionRecorder: interactionRecorder
        )

        return scene
    }

}
