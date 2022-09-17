import EurofurenceModel
import XCTest

class WhenLoggingIn: XCTestCase {

    private func makeLoginResponse(
        uid: String = "",
        username: String = "",
        token: String = "",
        tokenValidUntil: Date = Date()
    ) -> LoginResponse {
        return LoginResponse(userIdentifier: uid, username: username, token: token, tokenValidUntil: tokenValidUntil)
    }
    
    var context: EurofurenceSessionTestBuilder.Context!
    
    override func setUp() {
        super.setUp()

        context = EurofurenceSessionTestBuilder().build()
    }

    func testUsesLoginArgumentsAgainstAPI() {
        let username = "Some awesome guy"
        let registrationNumber = 42
        let password = "Some awesome password"
        let arguments = LoginArguments(registrationNumber: registrationNumber,
                                       username: username,
                                       password: password)
        context.authenticationService.login(arguments) { (_) in }
        let capturedLoginRequest: LoginRequest? = context.api.capturedLoginRequest

        XCTAssertEqual(username, capturedLoginRequest?.username)
        XCTAssertEqual(registrationNumber, capturedLoginRequest?.regNo)
        XCTAssertEqual(password, capturedLoginRequest?.password)
    }

    func testPersistsCredentialFromResponse() {
        let expectedUsername = "Some awesome guy"
        let expectedUserID = 42
        let expectedToken = "JWT Token"
        let expectedTokenExpiry = Date.distantFuture
        let arguments = LoginArguments(registrationNumber: expectedUserID,
                                       username: expectedUsername,
                                       password: "Not used for this test")
        let response = LoginResponse(userIdentifier: "",
                                     username: "",
                                     token: expectedToken,
                                     tokenValidUntil: .distantFuture)

        context.authenticationService.login(arguments, completionHandler: { (_) in })
        context.api.simulateLoginResponse(response)

        XCTAssertEqual(expectedUsername, context.credentialRepository.capturedCredential?.username)
        XCTAssertEqual(expectedUserID, context.credentialRepository.capturedCredential?.registrationNumber)
        XCTAssertEqual(expectedToken, context.credentialRepository.capturedCredential?.authenticationToken)
        XCTAssertEqual(expectedTokenExpiry, context.credentialRepository.capturedCredential?.tokenExpiryDate)
    }

    func testLoggingInSuccessfulyShouldNotifyObserversAboutIt() {
        let loginObserver = CapturingLoginObserver()
        context.login(completionHandler: loginObserver.completionHandler)
        context.api.simulateLoginResponse(makeLoginResponse())

        XCTAssertTrue(loginObserver.notifiedLoginSucceeded)
    }

    func testLoggingInSuccessfulyShouldNotNotifyObserversAboutItUntilTokenPersistenceCompletes() {
        let loginObserver = CapturingLoginObserver()
        context.credentialRepository.blockToRunBeforeCompletingCredentialStorage = {
            XCTAssertFalse(loginObserver.notifiedLoginSucceeded)
        }

        context.login(completionHandler: loginObserver.completionHandler)
        context.api.simulateLoginResponse(makeLoginResponse())
    }

    func testLoggingInSuccessfulyShouldNotNotifyObserversAboutLoginFailure() {
        let loginObserver = CapturingLoginObserver()
        context.login(completionHandler: loginObserver.completionHandler)
        context.api.simulateLoginResponse(makeLoginResponse())

        XCTAssertFalse(loginObserver.notifiedLoginFailed)
    }

    func testLoggingInSuccessfullyThenRegisteringPushTokenShouldProvideAuthTokenWithPushRegistration() {
        let expectedToken = "JWT Token"
        context.login()
        context.api.simulateLoginResponse(makeLoginResponse(token: expectedToken))
        context.notificationsService.storeRemoteNotificationsToken(Data())

        XCTAssertEqual(expectedToken, context.notificationTokenRegistration.capturedUserAuthenticationToken)
    }

    func testLoggingInAfterRegisteringPushTokenShouldReRegisterThePushTokenWithTheUserAuthenticationToken() {
        let expectedToken = "JWT Token"
        context.notificationsService.storeRemoteNotificationsToken(Data())
        context.login()
        context.api.simulateLoginResponse(makeLoginResponse(token: expectedToken))

        XCTAssertEqual(expectedToken, context.notificationTokenRegistration.capturedUserAuthenticationToken)
    }

    func testLoggingInSuccessfullyShouldProvideExpectedLoginToHandler() {
        let loginObserver = CapturingLoginObserver()
        let username = "Some cool guy"
        let regNo = 42
        context.login(registrationNumber: regNo, username: username, completionHandler: loginObserver.completionHandler)
        context.api.simulateLoginResponse(makeLoginResponse())

        XCTAssertEqual(username, loginObserver.loggedInUser?.username)
        XCTAssertEqual(regNo, loginObserver.loggedInUser?.registrationNumber)
    }
    
    func testSuccessfulLoginShouldRequestLatestMessages() {
        let loginObserver = CapturingLoginObserver()
        let username = "Some cool guy"
        let regNo = 42
        context.login(registrationNumber: regNo, username: username, completionHandler: loginObserver.completionHandler)
        context.api.simulateLoginResponse(makeLoginResponse())
        
        XCTAssertTrue(
            context.api.wasToldToLoadPrivateMessages,
            "Successful login should request the user's messages are loaded"
        )
    }

    func testSuccessfulLoginTellsObserversTheUserHasLoggedIn() {
        let observer = CapturingAuthenticationStateObserver()
        context.authenticationService.add(observer)
        let regNo: Int = .random
        let username: String = .random
        context.login(registrationNumber: regNo, username: username, completionHandler: { (_) in })
        context.api.simulateLoginResponse(makeLoginResponse())

        XCTAssertEqual(username, observer.capturedLoggedInUser?.username)
        XCTAssertEqual(regNo, observer.capturedLoggedInUser?.registrationNumber)
    }

    func testAddingObserverAfterSuccessfullyLoggingInTellsItAboutTheLoggedInUser() {
        let regNo: Int = .random
        let username: String = .random
        context.login(registrationNumber: regNo, username: username, completionHandler: { (_) in })
        context.api.simulateLoginResponse(makeLoginResponse())
        let observer = CapturingAuthenticationStateObserver()
        context.authenticationService.add(observer)

        XCTAssertEqual(username, observer.capturedLoggedInUser?.username)
        XCTAssertEqual(regNo, observer.capturedLoggedInUser?.registrationNumber)
    }

    func testLoggingOutTellsObserversTheUserHasLoggedOut() {
        let observer = CapturingAuthenticationStateObserver()
        context.authenticationService.add(observer)
        let user = User(registrationNumber: .random, username: .random)
        context.login(registrationNumber: user.registrationNumber, username: user.username)
        context.api.simulateLoginResponse(makeLoginResponse())
        context.authenticationService.logout(completionHandler: { (_) in })
        context.notificationTokenRegistration.succeedLastRequest()

        XCTAssertTrue(observer.loggedOut)
    }

    func testObserverNotToldUserLoggedOutUntilLogoutSucceeds() {
        let observer = CapturingAuthenticationStateObserver()
        context.authenticationService.add(observer)
        observer.loggedOut = false
        let user = User(registrationNumber: .random, username: .random)
        context.login(registrationNumber: user.registrationNumber, username: user.username)
        context.api.simulateLoginResponse(makeLoginResponse())
        context.authenticationService.logout(completionHandler: { (_) in })

        XCTAssertFalse(observer.loggedOut)
    }

    func testObserverNotToldUserLoggedOutWhenLogoutFails() {
        let observer = CapturingAuthenticationStateObserver()
        context.authenticationService.add(observer)
        observer.loggedOut = false
        let user = User(registrationNumber: .random, username: .random)
        context.login(registrationNumber: user.registrationNumber, username: user.username)
        context.api.simulateLoginResponse(makeLoginResponse())
        context.authenticationService.logout(completionHandler: { (_) in })
        context.notificationTokenRegistration.failLastRequest()

        XCTAssertFalse(observer.loggedOut)
    }

    func testAddingObserverWhenNotLoggedInTellsObserverUserLoggedOut() {
        let observer = CapturingAuthenticationStateObserver()
        context.authenticationService.add(observer)

        XCTAssertTrue(observer.loggedOut)
    }

}
