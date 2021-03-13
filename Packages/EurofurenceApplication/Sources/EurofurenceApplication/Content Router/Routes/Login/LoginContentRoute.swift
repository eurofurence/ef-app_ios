import Foundation
import UIKit.UIViewController

public struct LoginContentRoute {
    
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

// MARK: - ContentRoute

extension LoginContentRoute: ContentRoute {
    
    public typealias Content = LoginContentRepresentation
    
    public func route(_ content: LoginContentRepresentation) {
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
            completionHandler(success)
            viewController?.dismiss(animated: true)
        }
        
    }
    
}
