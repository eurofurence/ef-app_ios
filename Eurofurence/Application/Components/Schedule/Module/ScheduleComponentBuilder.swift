import Foundation
import UIKit.UIViewController

public class ScheduleModuleBuilder {

    private var eventsSceneFactory: ScheduleSceneFactory
    private let scheduleViewModelFactory: ScheduleViewModelFactory
    private var hapticEngine: SelectionChangedHaptic

    public init(scheduleViewModelFactory: ScheduleViewModelFactory) {
        self.scheduleViewModelFactory = scheduleViewModelFactory
        eventsSceneFactory = StoryboardScheduleSceneFactory()
        hapticEngine = CocoaTouchHapticEngine()
    }

    @discardableResult
    public func with(_ eventsSceneFactory: ScheduleSceneFactory) -> Self {
        self.eventsSceneFactory = eventsSceneFactory
        return self
    }

    @discardableResult
    public func with(_ hapticEngine: SelectionChangedHaptic) -> Self {
        self.hapticEngine = hapticEngine
        return self
    }

    public func build() -> ScheduleComponentFactory {
        ScheduleComponentFactoryImpl(
            eventsSceneFactory: eventsSceneFactory,
            scheduleViewModelFactory: scheduleViewModelFactory,
            hapticEngine: hapticEngine
        )
    }

}
