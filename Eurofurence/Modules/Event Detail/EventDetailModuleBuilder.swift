import Foundation
import UIKit.UIViewController

class EventDetailModuleBuilder {

    private var sceneFactory: EventDetailSceneFactory
    private var interactor: EventDetailInteractor
    private var hapticEngine: SelectionChangedHaptic

    init(interactor: EventDetailInteractor) {
        self.interactor = interactor
        sceneFactory = StoryboardEventDetailSceneFactory()
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
    func with(_ hapticEngine: SelectionChangedHaptic) -> EventDetailModuleBuilder {
        self.hapticEngine = hapticEngine
        return self
    }

    func build() -> EventDetailModuleProviding {
        return EventDetailModule(sceneFactory: sceneFactory,
                                 interactor: interactor,
                                 hapticEngine: hapticEngine)
    }

}
