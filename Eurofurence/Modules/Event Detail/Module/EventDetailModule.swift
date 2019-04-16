import EurofurenceModel
import Foundation
import UIKit.UIViewController

struct EventDetailModule: EventDetailModuleProviding {

    var sceneFactory: EventDetailSceneFactory
    var interactor: EventDetailInteractor
    var hapticEngine: SelectionChangedHaptic

    func makeEventDetailModule(for event: EventIdentifier) -> UIViewController {
        let scene = sceneFactory.makeEventDetailScene()
        _ = EventDetailPresenter(scene: scene,
                                 interactor: interactor,
                                 hapticEngine: hapticEngine,
                                 event: event)

        return scene
    }

}
