import EurofurenceModel
import Foundation
import UIKit.UIImage

struct AdditionalServicesPresenter: HybridWebSceneDelegate, AdditionalServicesURLConsumer {
    
    private let scene: HybridWebScene
    private let repository: AdditionalServicesRepository
    
    init(scene: HybridWebScene, repository: AdditionalServicesRepository) {
        self.scene = scene
        self.repository = repository
        
        scene.setSceneTitle(.additionalServices)
        scene.setSceneShortTitle(.services)
        
        let icon = UIImage(named: "Additional Services", in: .module, compatibleWith: nil)
        if let iconData = icon?.pngData() {
            scene.setSceneIcon(pngData: iconData)
        }
        
        scene.setDelegate(self)
    }
    
    func hybridWebSceneDidLoad() {
        repository.add(self)
    }
    
    func consume(_ additionalServicesURLRequest: URLRequest) {
        scene.loadContents(of: additionalServicesURLRequest)
    }
    
}
