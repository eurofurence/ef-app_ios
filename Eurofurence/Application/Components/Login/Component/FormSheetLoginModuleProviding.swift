import UIKit

struct FormSheetLoginComponentFactory: LoginComponentFactory {
    
    var loginComponentFactory: LoginComponentFactory
    
    func makeLoginModule(_ delegate: LoginComponentDelegate) -> UIViewController {
        let contentController = loginComponentFactory.makeLoginModule(delegate)
        let navigationController = UINavigationController(rootViewController: contentController)
        navigationController.modalPresentationStyle = .formSheet
        
        return navigationController
    }
    
}
