import ComponentBase
import UIKit.UIViewController

struct ScheduleComponentFactoryImpl: ScheduleComponentFactory {

    var eventsSceneFactory: ScheduleSceneFactory
    var scheduleViewModelFactory: ScheduleViewModelFactory
    var hapticEngine: SelectionChangedHaptic

    func makeScheduleComponent(_ delegate: ScheduleComponentDelegate) -> UIViewController {
        let scene = eventsSceneFactory.makeEventsScene()
        _ = SchedulePresenter(
            scene: scene,
            scheduleViewModelFactory: scheduleViewModelFactory,
            delegate: delegate,
            hapticEngine: hapticEngine
        )
        
        scene.setScheduleTitle(NSLocalizedString(
            "Schedule",
            bundle: .module,
            comment: "Title for the view that shows the convention schedule"
        ))

        return scene
    }

}
