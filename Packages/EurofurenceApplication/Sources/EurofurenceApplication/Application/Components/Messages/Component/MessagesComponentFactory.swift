import EurofurenceModel
import UIKit.UIViewController

public protocol MessagesComponentFactory {

    func makeMessagesModule(_ delegate: MessagesComponentDelegate) -> UIViewController

}

public protocol MessagesComponentDelegate {

    func messagesModuleDidRequestPresentation(for message: MessageIdentifier)
    func messagesModuleDidRequestDismissal()
    func showLogoutAlert(presentedHandler: @escaping (@escaping () -> Void) -> Void)
    func showLogoutFailedAlert()

}
