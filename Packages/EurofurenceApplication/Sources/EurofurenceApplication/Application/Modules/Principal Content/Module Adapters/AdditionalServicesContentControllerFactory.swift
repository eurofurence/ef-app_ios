import UIKit

struct AdditionalServicesContentControllerFactory: ApplicationModuleFactory {
    
    var additionalServicesComponentFactory: AdditionalServicesComponentFactory
    
    func makeApplicationModuleController() -> UIViewController {
        additionalServicesComponentFactory.makeAdditionalServicesComponent()
    }
    
}
