import Foundation

public struct LoginContentRoute {
    
    private let loginModuleFactory: LoginModuleProviding
    private let modalWireframe: ModalWireframe
    
    public init(
        loginModuleFactory: LoginModuleProviding,
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
        let contentController = loginModuleFactory.makeLoginModule(
            MapResponseToBlock(completionHandler: content.completionHandler)
        )
        
        modalWireframe.presentModalContentController(contentController)
    }
    
    private struct MapResponseToBlock: LoginModuleDelegate {
        
        var completionHandler: (Bool) -> Void
        
        func loginModuleDidCancelLogin() {
            completionHandler(false)
        }
        
        func loginModuleDidLoginSuccessfully() {
            completionHandler(true)
        }
        
    }
    
}
