import UIKit.UIViewController

struct ScheduleModule: ScheduleModuleProviding {

    var eventsSceneFactory: ScheduleSceneFactory
    var interactor: ScheduleInteractor
    var hapticEngine: SelectionChangedHaptic

    func makeScheduleModule(_ delegate: ScheduleModuleDelegate) -> UIViewController {
        let scene = eventsSceneFactory.makeEventsScene()
        _ = SchedulePresenter(scene: scene,
                              interactor: interactor,
                              delegate: delegate,
                              hapticEngine: hapticEngine)
        scene.setScheduleTitle(.schedule)

        return scene
    }

}
