import Eurofurence
import EurofurenceModel
import XCTest

class NavigateFromMessagesToMessageTests: XCTestCase {
    
    func testRoutesToMessageContent() {
        let router = FakeContentRouter()
        let presentingViewController = CapturingViewController()
        let navigator = NavigateFromMessagesToMessage(
            router: router,
            presentingViewController: presentingViewController
        )
        
        let message = MessageIdentifier.random
        
        navigator.messagesModuleDidRequestPresentation(for: message)
        let expected = MessageContentRepresentation(identifier: message)
        
        router.assertRouted(to: expected)
    }
    
    func testShowLogoutAlertWithExpectedText() {
        let router = FakeContentRouter()
        let presentingViewController = CapturingViewController()
        let navigator = NavigateFromMessagesToMessage(
            router: router,
            presentingViewController: presentingViewController
        )
        
        navigator.showLogoutAlert(presentedHandler: { (_) in
            
        })

        let presentedAlertController = presentingViewController.capturedPresentedViewController as? UIAlertController

        XCTAssertEqual(.loggingOut, presentedAlertController?.title)
        XCTAssertEqual(.loggingOutAlertDetail, presentedAlertController?.message)
    }

    func testShowLogoutErrorAlertWithExpectedText() {
        let router = FakeContentRouter()
        let presentingViewController = CapturingViewController()
        let navigator = NavigateFromMessagesToMessage(
            router: router,
            presentingViewController: presentingViewController
        )
        
        navigator.showLogoutFailedAlert()
        
        let presentedAlertController = presentingViewController.capturedPresentedViewController as? UIAlertController

        XCTAssertEqual(.logoutFailed, presentedAlertController?.title)
        XCTAssertEqual(.logoutFailedAlertDetail, presentedAlertController?.message)
    }

}
