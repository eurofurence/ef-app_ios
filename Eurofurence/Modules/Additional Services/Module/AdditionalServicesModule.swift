import UIKit.UIViewController

struct AdditionalServicesModule: AdditionalServicesModuleProviding {
    
    var sceneFactory: HybridWebSceneFactory
    
    func makeAdditionalServicesModule() -> UIViewController {
        let scene = sceneFactory.makeHybridWebScene()
        scene.setSceneTitle(.additionalServices)
        scene.setSceneShortTitle(.services)
        
        return scene
    }
    
}
