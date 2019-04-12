import Foundation
import UIKit.UIViewController

class EventDetailModuleBuilder {

    private var sceneFactory: EventDetailSceneFactory
    private var interactor: EventDetailInteractor
    private var hapticEngine: HapticEngine

    init() {
        sceneFactory = StoryboardEventDetailSceneFactory()
        interactor = DefaultEventDetailInteractor()
        hapticEngine = CocoaTouchHapticEngine()
    }

    @discardableResult
    func with(_ sceneFactory: EventDetailSceneFactory) -> EventDetailModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    @discardableResult
    func with(_ interactor: EventDetailInteractor) -> EventDetailModuleBuilder {
        self.interactor = interactor
        return self
    }

    @discardableResult
    func with(_ hapticEngine: HapticEngine) -> EventDetailModuleBuilder {
        self.hapticEngine = hapticEngine
        return self
    }

    func build() -> EventDetailModuleProviding {
        return EventDetailModule(sceneFactory: sceneFactory,
                                 interactor: interactor,
                                 hapticEngine: hapticEngine)
    }

}
