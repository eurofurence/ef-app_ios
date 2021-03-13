import EurofurenceApplication
import EurofurenceModel
import XCTest

class NavigateFromMessagesToMessageTests: XCTestCase {
    
    var router: FakeContentRouter!
    var modalWireframe: CapturingModalWireframe!
    var navigator: NavigateFromMessagesToMessage!
    
    override func setUp() {
        super.setUp()
        
        router = FakeContentRouter()
        modalWireframe = CapturingModalWireframe()
        navigator = NavigateFromMessagesToMessage(
            router: router,
            modalWireframe: modalWireframe
        )
    }
    
    func testRoutesToMessageContent() {
        let message = MessageIdentifier.random
        
        navigator.messagesModuleDidRequestPresentation(for: message)
        let expected = MessageContentRepresentation(identifier: message)
        
        router.assertRouted(to: expected)
    }
    
    func testShowLogoutAlertWithExpectedText() {
        navigator.showLogoutAlert(presentedHandler: { (_) in
            
        })

        let presentedAlertController = modalWireframe.presentedModalContentController as? UIAlertController

        XCTAssertEqual(.loggingOut, presentedAlertController?.title)
        XCTAssertEqual(.loggingOutAlertDetail, presentedAlertController?.message)
    }

    func testShowLogoutErrorAlertWithExpectedText() {
        navigator.showLogoutFailedAlert()
        
        let presentedAlertController = modalWireframe.presentedModalContentController as? UIAlertController

        XCTAssertEqual(.logoutFailed, presentedAlertController?.title)
        XCTAssertEqual(.logoutFailedAlertDetail, presentedAlertController?.message)
    }
    
    func testRequestingDismissal() {
        navigator.messagesModuleDidRequestDismissal()
        router.assertRouted(to: NewsContentRepresentation())
    }

}
