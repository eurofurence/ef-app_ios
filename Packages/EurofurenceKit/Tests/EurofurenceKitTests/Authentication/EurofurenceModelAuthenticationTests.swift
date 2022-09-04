import CoreData
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class EurofurenceModelAuthenticationTests: XCTestCase {
    
    func testModelNotAuthenticatedOnStart() async throws {
        let scenario = EurofurenceModelTestBuilder().with(keychain: UnauthenticatedKeychain()).build()
        XCTAssertEqual(.notAuthenticated, scenario.model.authenticationState)
    }
    
    func testModelAuthenticatedOnStart() async throws {
        let scenario = EurofurenceModelTestBuilder().with(keychain: AuthenticatedKeychain()).build()
        XCTAssertEqual(.authenticated, scenario.model.authenticationState)
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
        
        XCTAssertEqual(.authenticated, scenario.model.authenticationState)
        
        let expectedCredential = Credential(
            username: "Actual Username",
            registrationNumber: 99,
            authenticationToken: "Token",
            tokenExpiryDate: someDate
        )
        
        XCTAssertEqual(expectedCredential, keychain.setCredential)
    }
    
    func testAuthenticatingModel_LoginFails() async throws {
        let keychain = SpyKeychain(UnauthenticatedKeychain())
        let scenario = EurofurenceModelTestBuilder().with(keychain: keychain).build()
        let login = LoginParameters(registrationNumber: 108, username: "Some Guy", password: "donthackmebro")
        
        let expectedLogin = Login(registrationNumber: 108, username: "Some Guy", password: "donthackmebro")
        let error = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        await scenario.api.stubLoginAttempt(expectedLogin, with: .failure(error))
        
        await XCTAssertEventuallyThrowsSpecificError(EurofurenceError.loginFailed) {
            try await scenario.model.signIn(with: login)
        }
    }
    
    func testAuthenticatedModel_LoggingOut_Succeeds() async throws {
        
    }
    
    func testAuthenticatedModel_LoggingOut_Fails() async throws {
        
    }
    
    func testUnauthenticatedModel_LoggingOut_Fails() async throws {
        
    }
    
    func testAuthenticatingCachesPrivateMessages() async throws {
        
    }
    
    func testLoggingOutDeletesPrivateMessages() {
        
    }
    
    func testModelContainsCachedPrivateMessages_IsUnauthenticatedOnStart_DeletesPrivateMessages() {
        
    }

}
