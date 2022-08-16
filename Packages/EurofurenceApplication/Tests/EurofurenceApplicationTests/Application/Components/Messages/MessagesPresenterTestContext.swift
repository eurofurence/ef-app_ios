import EurofurenceApplication
import EurofurenceModel
import XCTComponentBase
import XCTEurofurenceModel

class CapturingMessagesComponentDelegate: MessagesComponentDelegate {

    private(set) var messageToShow: MessageIdentifier?
    func messagesModuleDidRequestPresentation(for message: MessageIdentifier) {
        messageToShow = message
    }

    private(set) var dismissed = false
    func messagesModuleDidRequestDismissal() {
        dismissed = true
    }

    private(set) var wasToldToShowLoggingOutAlert = false
    private(set) var capturedAlertPresentedBlock: ((@escaping () -> Void) -> Void)?
    func showLogoutAlert(presentedHandler: @escaping (@escaping () -> Void) -> Void) {
        wasToldToShowLoggingOutAlert = true
        capturedAlertPresentedBlock = presentedHandler
    }

    private(set) var wasToldToShowLogoutFailedAlert = false
    func showLogoutFailedAlert() {
        wasToldToShowLogoutFailedAlert = true
    }

}

struct MessagesPresenterTestContext {

    let sceneFactory = StubMessagesSceneFactory()
    let delegate = CapturingMessagesComponentDelegate()
    var privateMessagesService = CapturingPrivateMessagesService()
    let dateFormatter = CapturingDateFormatter()
    let authenticationService: FakeAuthenticationService
    let markdownRenderer = StubMarkdownRenderer()

    var scene: CapturingMessagesScene {
        return sceneFactory.scene
    }

    static func makeTestCaseForUnauthenticatedUser() -> MessagesPresenterTestContext {
        return MessagesPresenterTestContext(authState: .loggedOut)
    }

    static func makeTestCaseForAuthenticatedUser(
        _ user: User = User(registrationNumber: 42, username: ""),
        privateMessagesService: CapturingPrivateMessagesService = CapturingPrivateMessagesService()
    ) -> MessagesPresenterTestContext {
        return MessagesPresenterTestContext(authState: .loggedIn(user),
                                            privateMessagesService: privateMessagesService)
    }
    
    static func makeTestCaseForUserWithMessages(_ messages: [Message]) -> MessagesPresenterTestContext {
        let service = CapturingPrivateMessagesService(localMessages: messages)
        return makeTestCaseForAuthenticatedUser(privateMessagesService: service)
    }
    
    private init(
        authState: FakeAuthenticationService.AuthState,
        privateMessagesService: CapturingPrivateMessagesService = CapturingPrivateMessagesService()
    ) {
        self.privateMessagesService = privateMessagesService
        authenticationService = FakeAuthenticationService(authState: authState)
        _ = MessagesComponentBuilder(
            authenticationService: authenticationService,
            privateMessagesService: privateMessagesService
        )
        .with(sceneFactory)
        .with(dateFormatter)
        .with(markdownRenderer)
        .build()
        .makeMessagesModule(delegate)
    }

}
