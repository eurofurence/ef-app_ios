import Foundation
import UIKit.UIViewController

class EventDetailModuleBuilder {

    private let interactor: EventDetailInteractor
    private let interactionRecorder: EventInteractionRecorder
    private var sceneFactory: EventDetailSceneFactory
    private var hapticEngine: SelectionChangedHaptic

    init(interactor: EventDetailInteractor, interactionRecorder: EventInteractionRecorder) {
        self.interactor = interactor
        self.interactionRecorder = interactionRecorder
        
        sceneFactory = StoryboardEventDetailSceneFactory()
        hapticEngine = CocoaTouchHapticEngine()
    }

    @discardableResult
    func with(_ sceneFactory: EventDetailSceneFactory) -> EventDetailModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    @discardableResult
    func with(_ hapticEngine: SelectionChangedHaptic) -> EventDetailModuleBuilder {
        self.hapticEngine = hapticEngine
        return self
    }

    func build() -> EventDetailModuleProviding {
        return EventDetailModule(sceneFactory: sceneFactory,
                                 interactor: interactor,
                                 hapticEngine: hapticEngine,
                                 interactionRecorder: interactionRecorder)
    }

}
