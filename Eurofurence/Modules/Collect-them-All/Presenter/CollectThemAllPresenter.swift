import EurofurenceModel
import Foundation

struct CollectThemAllPresenter: HybridWebSceneDelegate, CollectThemAllURLObserver {

    private let scene: HybridWebScene
    private let service: CollectThemAllService

    init(scene: HybridWebScene, service: CollectThemAllService) {
        self.scene = scene
        self.service = service

        scene.setDelegate(self)
    }

    func hybridWebSceneDidLoad() {
        service.subscribe(self)
    }

    func collectThemAllGameRequestDidChange(_ urlRequest: URLRequest) {
        scene.loadContents(of: urlRequest)
    }

}
