import UIKit

struct FormSheetLoginModuleProviding: LoginModuleProviding {
    
    var loginModuleProviding: LoginModuleProviding
    
    func makeLoginModule(_ delegate: LoginModuleDelegate) -> UIViewController {
        let contentController = loginModuleProviding.makeLoginModule(delegate)
        let navigationController = UINavigationController(rootViewController: contentController)
        navigationController.modalPresentationStyle = .formSheet
        
        if #available(iOS 13.0, *) {
            navigationController.isModalInPresentation = true
        }
        
        return navigationController
    }
    
}
