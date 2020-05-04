import UIKit.UIViewController

public protocol AdditionalServicesModuleProviding {
    
    func makeAdditionalServicesModule() -> UIViewController
    
}
