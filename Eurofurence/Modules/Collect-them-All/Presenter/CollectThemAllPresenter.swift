import EurofurenceModel
import Foundation

struct CollectThemAllPresenter: CollectThemAllSceneDelegate, CollectThemAllURLObserver {

    private let scene: CollectThemAllScene
    private let service: CollectThemAllService

    init(scene: CollectThemAllScene, service: CollectThemAllService) {
        self.scene = scene
        self.service = service

        scene.setDelegate(self)
    }

    func collectThemAllSceneDidLoad() {
        service.subscribe(self)
    }

    func collectThemAllGameRequestDidChange(_ urlRequest: URLRequest) {
        scene.loadGame(at: urlRequest)
    }

}
