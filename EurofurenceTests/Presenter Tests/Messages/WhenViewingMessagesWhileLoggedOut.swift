@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenViewingMessagesWhileLoggedOut: XCTestCase {

    var context: MessagesPresenterTestContext!

    override func setUp() {
        super.setUp()

        context = MessagesPresenterTestContext.makeTestCaseForUnauthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
    }

    func testTheDelegateIsToldToResolveUserAuthentication() {
        XCTAssertTrue(context.delegate.wasToldToResolveUser)
    }

    func testTheMessagesTitleIsSetOntoTheScene() {
        XCTAssertEqual(.messages, context.scene.capturedTitle)
    }

    func testTheAuthServiceDoesNotDetermineAuthStateUntilTheSceneWillAppear() {
        let authenticationService = FakeAuthenticationService(authState: .loggedOut)
        _ = MessagesModuleBuilder()
            .with(StubMessagesSceneFactory())
            .with(authenticationService)
            .build()
            .makeMessagesModule(CapturingMessagesModuleDelegate())

        XCTAssertEqual(0, authenticationService.authStateDeterminedCount)
    }

    func testFailingToResolveUserTellsDelegateToDismissTheModule() {
        context.delegate.failToResolveUser()
        XCTAssertTrue(context.delegate.dismissed)
    }

    func testResolvingUserDoesNotTellDelegateToDismissTheModule() {
        context.delegate.resolveUser()
        XCTAssertFalse(context.delegate.dismissed)
    }

    func testTheSceneIsNotToldToShowRefreshIndicator() {
        XCTAssertFalse(context.scene.wasToldToShowRefreshIndicator)
    }

    func testThePrivateMessagesServiceIsNotToldToRefreshMessages() {
        XCTAssertFalse(context.privateMessagesService.wasToldToRefreshMessages)
    }

    func testResolvingUsersReloadsPrivateMessages() {
        context.delegate.resolveUser()
        XCTAssertTrue(context.privateMessagesService.wasToldToRefreshMessages)
    }

    func testResolvingUserTellsTheSceneIsToldToShowTheRefreshIndicator() {
        context.delegate.resolveUser()
        XCTAssertTrue(context.scene.wasToldToShowRefreshIndicator)
    }

    func testFailingToResolveUserDoesNotRefreshMessages() {
        context.delegate.failToResolveUser()
        XCTAssertFalse(context.privateMessagesService.wasToldToRefreshMessages)
    }

}
