@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class StubMessagesModuleFactory: MessagesModuleProviding {

    let stubInterface = UIViewController()
    private(set) var delegate: MessagesModuleDelegate?
    func makeMessagesModule(_ delegate: MessagesModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubMessagesModuleFactory {

    func simulateResolutionForUser(_ handler: @escaping (Bool) -> Void) {
        delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: handler)
    }

    func simulateMessagePresentationRequested(_ message: Message) {
        delegate?.messagesModuleDidRequestPresentation(for: message)
    }

    func simulateDismissalRequested() {
        delegate?.messagesModuleDidRequestDismissal()
    }

}
