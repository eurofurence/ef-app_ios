import ComponentBase
import RouterCore
import UIKit.UIViewController

public struct LoginRoute {
    
    private let loginModuleFactory: LoginComponentFactory
    private let modalWireframe: ModalWireframe
    
    public init(
        loginModuleFactory: LoginComponentFactory,
        modalWireframe: ModalWireframe
    ) {
        self.loginModuleFactory = loginModuleFactory
        self.modalWireframe = modalWireframe
    }
    
}

// MARK: - Route

extension LoginRoute: Route {
    
    public typealias Parameter = LoginRouteable
    
    public func route(_ content: LoginRouteable) {
        let delegate = MapResponseToBlock(completionHandler: content.completionHandler)
        let contentController = loginModuleFactory.makeLoginModule(delegate)
        delegate.viewController = contentController
        
        modalWireframe.presentModalContentController(contentController)
    }
    
    private class MapResponseToBlock: LoginComponentDelegate {
        
        private let completionHandler: (Bool) -> Void
        weak var viewController: UIViewController?
        
        init(completionHandler: @escaping (Bool) -> Void) {
            self.completionHandler = completionHandler
        }
        
        func loginModuleDidCancelLogin() {
            finalize(success: false)
        }
        
        func loginModuleDidLoginSuccessfully() {
            finalize(success: true)
        }
        
        private func finalize(success: Bool) {
            viewController?.dismiss(animated: true) { [completionHandler] in
                completionHandler(success)
            }
        }
        
    }
    
}
