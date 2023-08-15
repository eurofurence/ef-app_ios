import CoreData
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTAsyncAssertions
import XCTest

class EurofurenceModelAuthenticationTests: EurofurenceKitTestCase {
    
    func testModelNotAuthenticatedOnStart() async throws {
        let scenario = await EurofurenceModelTestBuilder().with(keychain: UnauthenticatedKeychain()).build()
        XCTAssertNil(scenario.model.currentUser)
    }
    
    func testModelAuthenticatedOnStart() async throws {
        let scenario = await EurofurenceModelTestBuilder().with(keychain: AuthenticatedKeychain()).build()
        
        let user = try XCTUnwrap(
            scenario.model.currentUser,
            "Authenticated user information from the keychain should be used to initialize the model"
        )
        
        XCTAssertEqual("Test User", user.name)
        XCTAssertEqual(42, user.registrationNumber)
    }
    
    func testAuthenticatingModel_LoginSucceeds() async throws {
        let keychain = SpyKeychain(UnauthenticatedKeychain())
        let scenario = await EurofurenceModelTestBuilder().with(keychain: keychain).build()
        let login = Login(registrationNumber: 108, username: "Some Guy", password: "donthackmebro")
        let someDate = Date().addingTimeInterval(3600)
        
        let expectedLogin = APIRequests.Login(
            registrationNumber: 108,
            username: "Some Guy",
            password: "donthackmebro"
        )
        
        let loginResponse = AuthenticatedUser(
            userIdentifier: 99,
            username: "Actual Username",
            token: "Token",
            tokenExpires: someDate
        )
        
        scenario.api.stub(request: expectedLogin, with: .success(loginResponse))
        
        await XCTAssertEventuallyNoThrows { try await scenario.model.signIn(with: login) }
        
        let user = try XCTUnwrap(
            scenario.model.currentUser,
            "Successful logins should update the current user"
        )
        
        XCTAssertEqual("Actual Username", user.name)
        XCTAssertEqual(99, user.registrationNumber)
        
        let expectedCredential = Credential(
            username: "Actual Username",
            registrationNumber: 99,
            authenticationToken: AuthenticationToken("Token"),
            tokenExpiryDate: someDate
        )
        
        XCTAssertEqual(expectedCredential, keychain.setCredential)
    }
    
    func testAuthenticatingModel_LoginFails() async throws {
        let scenario = await EurofurenceModelTestBuilder().with(keychain: UnauthenticatedKeychain()).build()
        let login = Login(registrationNumber: 108, username: "Some Guy", password: "donthackmebro")
        
        let expectedLogin = APIRequests.Login(registrationNumber: 108, username: "Some Guy", password: "donthackmebro")
        let error = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        scenario.api.stub(request: expectedLogin, with: .failure(error))
        
        await XCTAssertEventuallyThrowsSpecificError(EurofurenceError.loginFailed) {
            try await scenario.model.signIn(with: login)
        }
    }
    
    func testRegisteringRemoteNotificationsToken_ThenLoggingIn() async throws {
        let scenario = await EurofurenceModelTestBuilder().with(keychain: UnauthenticatedKeychain()).build()
        let deviceToken = try XCTUnwrap("Device Token".data(using: .utf8))
        await scenario.model.registerRemoteNotificationDeviceTokenData(deviceToken)
        
        let login = Login(registrationNumber: 108, username: "Some Guy", password: "donthackmebro")
        let expectedLogin = APIRequests.Login(registrationNumber: 108, username: "Some Guy", password: "donthackmebro")
        let loginResponse = AuthenticatedUser(
            userIdentifier: 99,
            username: "Actual Username",
            token: "Token",
            tokenExpires: .distantFuture
        )
        
        scenario.api.stub(request: expectedLogin, with: .success(loginResponse))
        await XCTAssertEventuallyNoThrows { try await scenario.model.signIn(with: login) }
        
        let expectedDeviceTokenRegistration = APIRequests.RegisterPushNotificationDeviceToken(
            authenticationToken: AuthenticationToken("Token"),
            pushNotificationDeviceToken: deviceToken
        )
        
        let registeredDeviceToken = scenario.api.executed(request: expectedDeviceTokenRegistration)
        XCTAssertTrue(registeredDeviceToken)
    }
    
    func testLoggingIn_ThenRegisteringRemoteNotificationDeviceToken() async throws {
        // TODO: Reenable once support for new IDP has been implemented
        throw XCTSkip("Login feature disabled due to deprecation.")
        let scenario = await EurofurenceModelTestBuilder().with(keychain: UnauthenticatedKeychain()).build()
        
        let login = Login(registrationNumber: 108, username: "Some Guy", password: "donthackmebro")
        let expectedLogin = APIRequests.Login(registrationNumber: 108, username: "Some Guy", password: "donthackmebro")
        let loginResponse = AuthenticatedUser(
            userIdentifier: 99,
            username: "Actual Username",
            token: "Token",
            tokenExpires: .distantFuture
        )
        
        scenario.api.stub(request: expectedLogin, with: .success(loginResponse))
        await XCTAssertEventuallyNoThrows { try await scenario.model.signIn(with: login) }
        
        let deviceToken = try XCTUnwrap("Device Token".data(using: .utf8))
        await scenario.model.registerRemoteNotificationDeviceTokenData(deviceToken)
        
        let expectedDeviceTokenRegistration = APIRequests.RegisterPushNotificationDeviceToken(
            authenticationToken: AuthenticationToken("Token"),
            pushNotificationDeviceToken: deviceToken
        )
        
        let registeredDeviceToken = scenario.api.executed(request: expectedDeviceTokenRegistration)
        XCTAssertTrue(registeredDeviceToken)
    }
    
    func testAuthenticatedModel_AssociatedDeviceToken_LoggingOutSucceeds_ClearsCredential() async throws {
        let keychain = AuthenticatedKeychain()
        let scenario = await EurofurenceModelTestBuilder().with(keychain: keychain).build()
        let deviceToken = try XCTUnwrap("Device Token".data(using: .utf8))
        await scenario.model.registerRemoteNotificationDeviceTokenData(deviceToken)
        
        let expectedLogoutRequest = APIRequests.Logout(pushNotificationDeviceToken: deviceToken)
        
        scenario.api.stub(request: expectedLogoutRequest, with: .success(()))
        
        await XCTAssertEventuallyNoThrows { try await scenario.model.signOut() }
        
        XCTAssertNil(keychain.credential)
        XCTAssertNil(scenario.model.currentUser)
    }
    
    func testAuthenticatedModel_NoAssociatedDeviceToken_LoggingOutSucceeds_ClearsCredential() async throws {
        let keychain = AuthenticatedKeychain()
        let scenario = await EurofurenceModelTestBuilder().with(keychain: keychain).build()
        
        let expectedLogoutRequest = APIRequests.Logout(pushNotificationDeviceToken: nil)
        
        scenario.api.stub(request: expectedLogoutRequest, with: .success(()))
        
        await XCTAssertEventuallyNoThrows { try await scenario.model.signOut() }
        
        XCTAssertNil(keychain.credential)
        XCTAssertNil(scenario.model.currentUser)
    }
    
    func testAuthenticatedModel_LoggingOutFails_DoesNotClearCredential() async throws {
        let keychain = AuthenticatedKeychain()
        let scenario = await EurofurenceModelTestBuilder().with(keychain: keychain).build()
        
        let expectedLogoutRequest = APIRequests.Logout(pushNotificationDeviceToken: nil)
        
        let error = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        scenario.api.stub(request: expectedLogoutRequest, with: .failure(error))
        
        await XCTAssertEventuallyThrowsError { try await scenario.model.signOut() }
        
        XCTAssertNotNil(keychain.credential)
        XCTAssertNotNil(scenario.model.currentUser)
    }
    
    func testUnauthenticated_DeviceTokenAvailable_StillAssociatesDeviceTokenForNonPersonalisedMessages() async throws {
        let scenario = await EurofurenceModelTestBuilder().with(keychain: UnauthenticatedKeychain()).build()
        let deviceToken = try XCTUnwrap("Device Token".data(using: .utf8))
        await scenario.model.registerRemoteNotificationDeviceTokenData(deviceToken)
        
        let expectedDeviceTokenRegistration = APIRequests.RegisterPushNotificationDeviceToken(
            authenticationToken: nil,
            pushNotificationDeviceToken: deviceToken
        )
        
        let registeredDeviceToken = scenario.api.executed(request: expectedDeviceTokenRegistration)
        XCTAssertTrue(registeredDeviceToken)
    }
    
    func testSigningInWithExpiredCredentialAutomaticallySignsUserOut() async throws {
        let api = FakeEurofurenceAPI()
        api.stub(request: APIRequests.Logout(pushNotificationDeviceToken: nil), with: .success(()))
        
        let keychain = ExpiredCredentialKeychain()
        let scenario = await EurofurenceModelTestBuilder().with(keychain: keychain).with(api: api).build()
        
        XCTAssertNil(scenario.model.currentUser, "Booted with expired credential - should not appear signed in")
        XCTAssertNil(keychain.credential, "Credential expired - should be removed from keychain")
    }
    
    func testAutomaticSignOutFails_NextLoginReattemptsSignOut() async throws {
        let api = FakeEurofurenceAPI()
        let error = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        api.stub(request: APIRequests.Logout(pushNotificationDeviceToken: nil), with: .failure(error))
        
        let keychain = ExpiredCredentialKeychain()
        await EurofurenceModelTestBuilder().with(keychain: keychain).with(api: api).build()
        
        XCTAssertNotNil(
            keychain.credential,
            "Automatic sign out failed - should retain the token for another attempt on next boot"
        )
        
        api.stub(request: APIRequests.Logout(pushNotificationDeviceToken: nil), with: .success(()))
        
        let scenario = await EurofurenceModelTestBuilder().with(keychain: keychain).with(api: api).build()
        
        XCTAssertNil(keychain.credential, "Automatic sign out succeeded - token should be cleared from keychain")
        XCTAssertNil(scenario.model.currentUser, "Booted with expired credential - should not appear signed in")
    }
    
    func testOnNextStoreUpdate_CredentialHasNowExpired_UserAutomaticallySignedOut() async throws {
        let api = FakeEurofurenceAPI()
        api.stub(request: APIRequests.Logout(pushNotificationDeviceToken: nil), with: .success(()))
        
        let keychain = AuthenticatedKeychain()
        let scenario = await EurofurenceModelTestBuilder().with(keychain: keychain).with(api: api).build()
        var expiredCredential = keychain.credential
        expiredCredential?.tokenExpiryDate = .distantPast
        keychain.credential = expiredCredential
        
        try await scenario.updateLocalStore(using: .ef26)
        
        XCTAssertNil(keychain.credential, "Automatic sign out succeeded - token should be cleared from keychain")
        XCTAssertNil(scenario.model.currentUser, "Updated store with expired credential - should not appear signed in")
    }

}
