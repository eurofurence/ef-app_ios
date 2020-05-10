import UIKit

struct AdditionalServicesContentControllerFactory: ApplicationModuleFactory {
    
    var additionalServicesModuleProviding: AdditionalServicesModuleProviding
    
    func makeApplicationModuleController() -> UIViewController {
        additionalServicesModuleProviding.makeAdditionalServicesModule()
    }
    
}
