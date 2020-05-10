import Foundation
import UIKit.UIViewController

class EventDetailComponentBuilder {

    private let interactor: EventDetailViewModelFactory
    private let interactionRecorder: EventInteractionRecorder
    private var sceneFactory: EventDetailSceneFactory
    private var hapticEngine: SelectionChangedHaptic

    init(interactor: EventDetailViewModelFactory, interactionRecorder: EventInteractionRecorder) {
        self.interactor = interactor
        self.interactionRecorder = interactionRecorder
        
        sceneFactory = StoryboardEventDetailSceneFactory()
        hapticEngine = CocoaTouchHapticEngine()
    }

    @discardableResult
    func with(_ sceneFactory: EventDetailSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }

    @discardableResult
    func with(_ hapticEngine: SelectionChangedHaptic) -> Self {
        self.hapticEngine = hapticEngine
        return self
    }

    func build() -> EventDetailComponentFactory {
        EventDetailComponentFactoryImpl(
            sceneFactory: sceneFactory,
            interactor: interactor,
            hapticEngine: hapticEngine,
            interactionRecorder: interactionRecorder
        )
    }

}
