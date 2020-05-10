import Eurofurence
import UIKit

class StubAdditionalServicesComponentFactory: AdditionalServicesComponentFactory {
    
    let stubInterface = UIViewController()
    func makeAdditionalServicesComponent() -> UIViewController {
        return stubInterface
    }
    
}
