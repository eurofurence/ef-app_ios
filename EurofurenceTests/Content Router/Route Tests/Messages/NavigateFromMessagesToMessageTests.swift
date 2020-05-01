import Eurofurence
import EurofurenceModel
import XCTest

class NavigateFromMessagesToMessageTests: XCTestCase {
    
    func testRoutesToMessageContent() {
        let router = FakeContentRouter()
        let modalWireframe = CapturingModalWireframe()
        let navigator = NavigateFromMessagesToMessage(
            router: router,
            modalWireframe: modalWireframe
        )
        
        let message = MessageIdentifier.random
        
        navigator.messagesModuleDidRequestPresentation(for: message)
        let expected = MessageContentRepresentation(identifier: message)
        
        router.assertRouted(to: expected)
    }
    
    func testShowLogoutAlertWithExpectedText() {
        let router = FakeContentRouter()
        let modalWireframe = CapturingModalWireframe()
        let navigator = NavigateFromMessagesToMessage(
            router: router,
            modalWireframe: modalWireframe
        )
        
        navigator.showLogoutAlert(presentedHandler: { (_) in
            
        })

        let presentedAlertController = modalWireframe.presentedModalContentController as? UIAlertController

        XCTAssertEqual(.loggingOut, presentedAlertController?.title)
        XCTAssertEqual(.loggingOutAlertDetail, presentedAlertController?.message)
    }

    func testShowLogoutErrorAlertWithExpectedText() {
        let router = FakeContentRouter()
        let modalWireframe = CapturingModalWireframe()
        let navigator = NavigateFromMessagesToMessage(
            router: router,
            modalWireframe: modalWireframe
        )
        
        navigator.showLogoutFailedAlert()
        
        let presentedAlertController = modalWireframe.presentedModalContentController as? UIAlertController

        XCTAssertEqual(.logoutFailed, presentedAlertController?.title)
        XCTAssertEqual(.logoutFailedAlertDetail, presentedAlertController?.message)
    }

}
