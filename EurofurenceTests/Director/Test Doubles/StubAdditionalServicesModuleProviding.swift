import Eurofurence
import UIKit

class StubAdditionalServicesModuleProviding: AdditionalServicesModuleProviding {
    
    let stubInterface = UIViewController()
    func makeAdditionalServicesModule() -> UIViewController {
        return stubInterface
    }
    
}
