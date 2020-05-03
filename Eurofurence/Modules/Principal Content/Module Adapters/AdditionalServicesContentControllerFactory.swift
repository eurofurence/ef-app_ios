import UIKit

struct AdditionalServicesContentControllerFactory: ContentControllerFactory {
    
    var additionalServicesModuleProviding: AdditionalServicesModuleProviding
    
    func makeContentController() -> UIViewController {
        additionalServicesModuleProviding.makeAdditionalServicesModule()
    }
    
}
