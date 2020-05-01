import EurofurenceModel
import UIKit

public struct NavigateFromMessagesToMessage: MessagesModuleDelegate {
    
    private let router: ContentRouter
    private let modalWireframe: ModalWireframe
    
    public init(router: ContentRouter, modalWireframe: ModalWireframe) {
        self.router = router
        self.modalWireframe = modalWireframe
    }
    
    public func messagesModuleDidRequestResolutionForUser(completionHandler: @escaping (Bool) -> Void) {
        
    }
    
    public func messagesModuleDidRequestPresentation(for message: MessageIdentifier) {
        try? router.route(MessageContentRepresentation(identifier: message))
    }
    
    public func messagesModuleDidRequestDismissal() {
        
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
