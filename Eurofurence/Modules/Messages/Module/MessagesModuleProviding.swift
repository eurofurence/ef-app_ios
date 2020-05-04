import EurofurenceModel
import UIKit.UIViewController

public protocol MessagesModuleProviding {

    func makeMessagesModule(_ delegate: MessagesModuleDelegate) -> UIViewController

}

public protocol MessagesModuleDelegate {

    func messagesModuleDidRequestResolutionForUser(completionHandler: @escaping (Bool) -> Void)
    func messagesModuleDidRequestPresentation(for message: MessageIdentifier)
    func messagesModuleDidRequestDismissal()
    func showLogoutAlert(presentedHandler: @escaping (@escaping () -> Void) -> Void)
    func showLogoutFailedAlert()

}
