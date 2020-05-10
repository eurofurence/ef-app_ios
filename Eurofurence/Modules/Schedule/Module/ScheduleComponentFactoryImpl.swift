import UIKit.UIViewController

struct ScheduleComponentFactoryImpl: ScheduleComponentFactory {

    var eventsSceneFactory: ScheduleSceneFactory
    var interactor: ScheduleInteractor
    var hapticEngine: SelectionChangedHaptic

    func makeScheduleComponent(_ delegate: ScheduleComponentDelegate) -> UIViewController {
        let scene = eventsSceneFactory.makeEventsScene()
        _ = SchedulePresenter(
            scene: scene,
            interactor: interactor,
            delegate: delegate,
            hapticEngine: hapticEngine
        )
        
        scene.setScheduleTitle(.schedule)

        return scene
    }

}
