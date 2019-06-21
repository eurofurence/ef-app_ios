@testable import Eurofurence
import EurofurenceModelTestDoubles
import UIKit

class AdditionalServicesPresenterTestBuilder {
    
    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingHybridWebScene
        var service: FakeAdditionalServicesRepository
    }
    
    func build() -> Context {
        let sceneFactory = StubHybridWebSceneFactory()
        let service = FakeAdditionalServicesRepository()
        let module = AdditionalServicesModuleBuilder(service: service)
            .with(sceneFactory)
            .build()
            .makeAdditionalServicesModule()
        
        return Context(producedViewController: module,
                       scene: sceneFactory.interface,
                       service: service)
    }
    
}

extension AdditionalServicesPresenterTestBuilder.Context {
    
    func simulateSceneDidLoad() {
        scene.delegate?.hybridWebSceneDidLoad()
    }
    
}
