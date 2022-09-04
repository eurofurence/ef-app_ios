import CoreData
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class EurofurenceModelAuthenticationTests: XCTestCase {
    
    func testModelNotAuthenticatedOnStart() async throws {
        let scenario = EurofurenceModelTestBuilder().with(keychain: UnauthenticatedKeychain()).build()
        XCTAssertNil(scenario.model.currentUser)
    }
    
    func testModelAuthenticatedOnStart() async throws {
        let scenario = EurofurenceModelTestBuilder().with(keychain: AuthenticatedKeychain()).build()
        
        let user = try XCTUnwrap(
            scenario.model.currentUser,
            "Authenticated user information from the keychain should be used to initialize the model"
        )
        
        XCTAssertEqual("Test User", user.name)
        XCTAssertEqual(42, user.registrationNumber)
    }
    
    func testAuthenticatingModel_LoginSucceeds() async throws {
        let keychain = SpyKeychain(UnauthenticatedKeychain())
        let scenario = EurofurenceModelTestBuilder().with(keychain: keychain).build()
        let login = LoginParameters(registrationNumber: 108, username: "Some Guy", password: "donthackmebro")
        let someDate = Date().addingTimeInterval(3600)
        
        let expectedLogin = Login(
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
        
        await scenario.api.stubLoginAttempt(expectedLogin, with: .success(loginResponse))
        
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
        let scenario = EurofurenceModelTestBuilder().with(keychain: UnauthenticatedKeychain()).build()
        let login = LoginParameters(registrationNumber: 108, username: "Some Guy", password: "donthackmebro")
        
        let expectedLogin = Login(registrationNumber: 108, username: "Some Guy", password: "donthackmebro")
        let error = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        await scenario.api.stubLoginAttempt(expectedLogin, with: .failure(error))
        
        await XCTAssertEventuallyThrowsSpecificError(EurofurenceError.loginFailed) {
            try await scenario.model.signIn(with: login)
        }
    }
    
    func testRegisteringRemoteNotificationsToken_ThenLoggingIn() async throws {
        let scenario = EurofurenceModelTestBuilder().with(keychain: UnauthenticatedKeychain()).build()
        let deviceToken = try XCTUnwrap("Device Token".data(using: .utf8))
        await scenario.model.registerRemoteNotificationDeviceTokenData(deviceToken)
        
        let login = LoginParameters(registrationNumber: 108, username: "Some Guy", password: "donthackmebro")
        let expectedLogin = Login(registrationNumber: 108, username: "Some Guy", password: "donthackmebro")
        let loginResponse = AuthenticatedUser(
            userIdentifier: 99,
            username: "Actual Username",
            token: "Token",
            tokenExpires: .distantFuture
        )
        
        await scenario.api.stubLoginAttempt(expectedLogin, with: .success(loginResponse))
        await XCTAssertEventuallyNoThrows { try await scenario.model.signIn(with: login) }
        
        let expectedDeviceTokenRegistration = RegisterPushNotificationDeviceToken(
            authenticationToken: AuthenticationToken("Token"),
            pushNotificationDeviceToken: deviceToken
        )
        
        let actualRegistration = await scenario.api.registeredDeviceTokenRequest
        XCTAssertEqual(expectedDeviceTokenRegistration, actualRegistration)
    }
    
    func testLoggingIn_ThenRegisteringRemoteNotificationDeviceToken() async throws {
        let scenario = EurofurenceModelTestBuilder().with(keychain: UnauthenticatedKeychain()).build()
        
        let login = LoginParameters(registrationNumber: 108, username: "Some Guy", password: "donthackmebro")
        let expectedLogin = Login(registrationNumber: 108, username: "Some Guy", password: "donthackmebro")
        let loginResponse = AuthenticatedUser(
            userIdentifier: 99,
            username: "Actual Username",
            token: "Token",
            tokenExpires: .distantFuture
        )
        
        await scenario.api.stubLoginAttempt(expectedLogin, with: .success(loginResponse))
        await XCTAssertEventuallyNoThrows { try await scenario.model.signIn(with: login) }
        
        let deviceToken = try XCTUnwrap("Device Token".data(using: .utf8))
        await scenario.model.registerRemoteNotificationDeviceTokenData(deviceToken)
        
        let expectedDeviceTokenRegistration = RegisterPushNotificationDeviceToken(
            authenticationToken: AuthenticationToken("Token"),
            pushNotificationDeviceToken: deviceToken
        )
        
        let actualRegistration = await scenario.api.registeredDeviceTokenRequest
        XCTAssertEqual(expectedDeviceTokenRegistration, actualRegistration)
    }
    
    func testAuthenticatedModel_AssociatedDeviceToken_LoggingOutSucceeds_ClearsCredential() async throws {
        let keychain = AuthenticatedKeychain()
        let scenario = EurofurenceModelTestBuilder().with(keychain: keychain).build()
        let deviceToken = try XCTUnwrap("Device Token".data(using: .utf8))
        await scenario.model.registerRemoteNotificationDeviceTokenData(deviceToken)
        
        let expectedLogoutRequest = Logout(
            authenticationToken: AuthenticationToken("ABC"),
            pushNotificationDeviceToken: deviceToken
        )
        
        await scenario.api.stubLogoutRequest(expectedLogoutRequest, with: .success(()))
        
        await XCTAssertEventuallyNoThrows { try await scenario.model.signOut() }
        
        XCTAssertNil(keychain.credential)
        XCTAssertNil(scenario.model.currentUser)
    }
    
    func testAuthenticatedModel_NoAssociatedDeviceToken_LoggingOutSucceeds_ClearsCredential() async throws {
        let keychain = AuthenticatedKeychain()
        let scenario = EurofurenceModelTestBuilder().with(keychain: keychain).build()
        
        let expectedLogoutRequest = Logout(
            authenticationToken: AuthenticationToken("ABC"),
            pushNotificationDeviceToken: nil
        )
        
        await scenario.api.stubLogoutRequest(expectedLogoutRequest, with: .success(()))
        
        await XCTAssertEventuallyNoThrows { try await scenario.model.signOut() }
        
        XCTAssertNil(keychain.credential)
        XCTAssertNil(scenario.model.currentUser)
    }
    
    func testAuthenticatedModel_LoggingOutFails_DoesNotClearCredential() async throws {
        let keychain = AuthenticatedKeychain()
        let scenario = EurofurenceModelTestBuilder().with(keychain: keychain).build()
        
        let expectedLogoutRequest = Logout(
            authenticationToken: AuthenticationToken("ABC"),
            pushNotificationDeviceToken: nil
        )
        
        let error = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        await scenario.api.stubLogoutRequest(expectedLogoutRequest, with: .failure(error))
        
        await XCTAssertEventuallyThrowsError { try await scenario.model.signOut() }
        
        XCTAssertNotNil(keychain.credential)
        XCTAssertNotNil(scenario.model.currentUser)
    }
    
    func testAuthenticatingCachesPrivateMessages() async throws {
        
    }
    
    func testLoggingOutDeletesPrivateMessages() {
        
    }
    
    func testModelContainsCachedPrivateMessages_TokenExpiresOnStart_DeletesPrivateMessages() {
        
    }

}
