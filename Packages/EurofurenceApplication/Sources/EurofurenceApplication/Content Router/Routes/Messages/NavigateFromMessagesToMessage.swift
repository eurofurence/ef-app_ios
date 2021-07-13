import ComponentBase
import EurofurenceModel
import RouterCore
import UIKit

public struct NavigateFromMessagesToMessage: MessagesComponentDelegate {
    
    private let router: Router
    private let modalWireframe: ModalWireframe
    
    public init(router: Router, modalWireframe: ModalWireframe) {
        self.router = router
        self.modalWireframe = modalWireframe
    }
    
    public func messagesModuleDidRequestPresentation(for message: MessageIdentifier) {
        try? router.route(MessageRouteable(identifier: message))
    }
    
    public func messagesModuleDidRequestDismissal() {
        try? router.route(NewsRouteable())
    }
    
    public func showLogoutAlert(presentedHandler: @escaping (@escaping () -> Void) -> Void) {
        let alert = UIAlertController(title: .loggingOut, message: .loggingOutAlertDetail, preferredStyle: .alert)
        modalWireframe.presentModalContentController(
            alert,
            completion: { presentedHandler({ alert.dismiss(animated: true) }) }
        )
    }
    
    public func showLogoutFailedAlert() {
        let alert = UIAlertController(
            title: .logoutFailed,
            message: .logoutFailedAlertDetail,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: .ok, style: .cancel))
        modalWireframe.presentModalContentController(alert)
    }
    
}
