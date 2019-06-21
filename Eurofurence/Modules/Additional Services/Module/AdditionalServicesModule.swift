import UIKit.UIViewController

struct AdditionalServicesModule: AdditionalServicesModuleProviding {
    
    var sceneFactory: HybridWebSceneFactory
    
    func makeAdditionalServicesModule() -> UIViewController {
        let scene = sceneFactory.makeHybridWebScene()
        _ = AdditionalServicesPresenter(scene: scene)
        
        return scene
    }
    
}
