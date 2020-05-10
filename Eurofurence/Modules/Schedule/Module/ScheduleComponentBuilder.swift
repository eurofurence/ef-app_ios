import Foundation
import UIKit.UIViewController

class ScheduleModuleBuilder {

    private var eventsSceneFactory: ScheduleSceneFactory
    private let interactor: ScheduleViewModelFactory
    private var hapticEngine: SelectionChangedHaptic

    init(interactor: ScheduleViewModelFactory) {
        self.interactor = interactor
        eventsSceneFactory = StoryboardScheduleSceneFactory()
        hapticEngine = CocoaTouchHapticEngine()
    }

    @discardableResult
    func with(_ eventsSceneFactory: ScheduleSceneFactory) -> ScheduleModuleBuilder {
        self.eventsSceneFactory = eventsSceneFactory
        return self
    }

    @discardableResult
    func with(_ hapticEngine: SelectionChangedHaptic) -> ScheduleModuleBuilder {
        self.hapticEngine = hapticEngine
        return self
    }

    func build() -> ScheduleComponentFactory {
        ScheduleComponentFactoryImpl(
            eventsSceneFactory: eventsSceneFactory,
            interactor: interactor,
            hapticEngine: hapticEngine
        )
    }

}
