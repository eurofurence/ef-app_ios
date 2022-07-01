import EurofurenceModel
import UIKit.UIViewController

struct AdditionalServicesComponentFactoryImpl: AdditionalServicesComponentFactory {
    
    var repository: AdditionalServicesRepository
    var sceneFactory: HybridWebSceneFactory
    
    func makeAdditionalServicesComponent() -> UIViewController {
        let scene = sceneFactory.makeHybridWebScene()
        _ = AdditionalServicesPresenter(scene: scene, repository: repository)
        scene.tabBarItem.image = UIImage(systemName: "books.vertical")
        scene.tabBarItem.selectedImage = UIImage(systemName: "books.vertical.fill")
        
        return scene
    }
    
}
