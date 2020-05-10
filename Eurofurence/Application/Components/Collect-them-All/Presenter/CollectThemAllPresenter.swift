import EurofurenceModel
import Foundation
import UIKit.UIImage

struct CollectThemAllPresenter: HybridWebSceneDelegate, CollectThemAllURLObserver {

    private let scene: HybridWebScene
    private let service: CollectThemAllService

    init(scene: HybridWebScene, service: CollectThemAllService) {
        self.scene = scene
        self.service = service

        scene.setSceneShortTitle(.collect)
        scene.setSceneTitle(.collectThemAll)
        UIImage(named: "Collectemall-50", in: .main, compatibleWith: nil)?.pngData().let(scene.setSceneIcon)
        
        scene.setDelegate(self)
    }

    func hybridWebSceneDidLoad() {
        service.subscribe(self)
    }

    func collectThemAllGameRequestDidChange(_ urlRequest: URLRequest) {
        scene.loadContents(of: urlRequest)
    }

}
