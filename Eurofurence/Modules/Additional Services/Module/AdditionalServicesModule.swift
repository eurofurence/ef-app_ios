import EurofurenceModel
import UIKit.UIViewController

struct AdditionalServicesModule: AdditionalServicesModuleProviding {
    
    var repository: AdditionalServicesRepository
    var sceneFactory: HybridWebSceneFactory
    
    func makeAdditionalServicesModule() -> UIViewController {
        let scene = sceneFactory.makeHybridWebScene()
        _ = AdditionalServicesPresenter(scene: scene, repository: repository)
        
        return scene
    }
    
}
