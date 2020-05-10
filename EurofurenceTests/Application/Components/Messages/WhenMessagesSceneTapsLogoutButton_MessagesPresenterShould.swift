@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenMessagesSceneTapsLogoutButton_MessagesPresenterShould: XCTestCase {

    func testTellTheDelegateToShowTheLoggingOutAlert() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneReady()
        context.scene.delegate?.messagesSceneDidTapLogoutButton()

        XCTAssertTrue(context.delegate.wasToldToShowLoggingOutAlert)
    }

    func testTellTheAuthenticationServiceToLogoutWhenTheLoginAlertIsPresented() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneReady()
        context.scene.delegate?.messagesSceneDidTapLogoutButton()
        context.delegate.capturedAlertPresentedBlock?({})

        XCTAssertTrue(context.authenticationService.wasToldToLogout)
    }

    func testInvokeTheAlertDismissalBlockWhenAuthenticationServiceFinishes() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneReady()
        context.scene.delegate?.messagesSceneDidTapLogoutButton()
        var didInvokeDismissalHandlerForPresentedLogoutAlert = false
        context.delegate.capturedAlertPresentedBlock?({ didInvokeDismissalHandlerForPresentedLogoutAlert = true })
        context.authenticationService.capturedLogoutHandler?(.success)

        XCTAssertTrue(didInvokeDismissalHandlerForPresentedLogoutAlert)
    }

    func testTellTheDelegateToDismissTheMessagesModuleWhenLogoutSucceeds() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneReady()
        context.scene.delegate?.messagesSceneDidTapLogoutButton()
        context.delegate.capturedAlertPresentedBlock?({})
        context.authenticationService.capturedLogoutHandler?(.success)

        XCTAssertTrue(context.delegate.dismissed)
    }

    func testTellTheDelegateToShowTheLogoutFailedAlertWhenLogoutSucceeds() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneReady()
        context.scene.delegate?.messagesSceneDidTapLogoutButton()
        context.delegate.capturedAlertPresentedBlock?({})
        context.authenticationService.capturedLogoutHandler?(.failure)

        XCTAssertTrue(context.delegate.wasToldToShowLogoutFailedAlert)
    }

}
