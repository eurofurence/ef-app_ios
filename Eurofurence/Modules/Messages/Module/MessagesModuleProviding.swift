import EurofurenceModel
import UIKit.UIViewController

protocol MessagesModuleProviding {

    func makeMessagesModule(_ delegate: MessagesModuleDelegate) -> UIViewController

}

protocol MessagesModuleDelegate {

    func messagesModuleDidRequestResolutionForUser(completionHandler: @escaping (Bool) -> Void)
    func messagesModuleDidRequestPresentation(for message: Message)
    func messagesModuleDidRequestDismissal()
    func showLogoutAlert(presentedHandler: @escaping (@escaping () -> Void) -> Void)
    func showLogoutFailedAlert()

}
