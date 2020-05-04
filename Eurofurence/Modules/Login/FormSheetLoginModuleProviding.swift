import UIKit

struct FormSheetLoginModuleProviding: LoginModuleProviding {
    
    var loginModuleProviding: LoginModuleProviding
    
    func makeLoginModule(_ delegate: LoginModuleDelegate) -> UIViewController {
        let contentController = loginModuleProviding.makeLoginModule(delegate)
        let navigationController = UINavigationController(rootViewController: contentController)
        navigationController.modalPresentationStyle = .formSheet
        
        return navigationController
    }
    
}
