import EurofurenceModel
import Foundation

struct CollectThemAllPresenter: CollectThemAllSceneDelegate, CollectThemAllURLObserver {

    private let scene: CollectThemAllScene
    private let service: CollectThemAllService
    private let interactionRecorder: CollectThemAllInteractionRecorder

    init(scene: CollectThemAllScene, service: CollectThemAllService, interactionRecorder: CollectThemAllInteractionRecorder) {
        self.scene = scene
        self.service = service
        self.interactionRecorder = interactionRecorder

        scene.setDelegate(self)
    }

    func collectThemAllSceneDidLoad() {
        interactionRecorder.recordCollectThemAllInteraction()
        service.subscribe(self)
    }

    func collectThemAllGameRequestDidChange(_ urlRequest: URLRequest) {
        scene.loadGame(at: urlRequest)
    }

}
