import EurofurenceKit
import EurofurenceWebAPI
import XCTAsyncAssertions
import XCTest

class EurofurenceModelMessagesTests: XCTestCase {
    
    func testWhenSignedInMessagesAreCachedIntoContext() async throws {
        let scenario = EurofurenceModelTestBuilder().with(keychain: UnauthenticatedKeychain()).build()
        let login = Login(registrationNumber: 42, username: "Some Guy", password: "p455w0rd")
        let loginRequest = LoginRequest(registrationNumber: 42, username: "Some Guy", password: "p455w0rd")
        let user = AuthenticatedUser(
            userIdentifier: 42,
            username: "Some Guy",
            token: "Token",
            tokenExpires: .distantFuture
        )
        
        let (firstReceived, firstRead) = (Date(), Date())
        let secondReceived = Date()
        let messages = [
            EurofurenceWebAPI.Message(
                id: "First Identifier",
                author: "First Author",
                subject: "First Subject",
                message: "First Message",
                receivedDate: firstReceived,
                readDate: firstRead
            ),
            
            EurofurenceWebAPI.Message(
                id: "Second Identifier",
                author: "Second Author",
                subject: "Second Subject",
                message: "Second Message",
                receivedDate: secondReceived,
                readDate: nil
            )
        ]
        
        await scenario.api.stubLoginAttempt(loginRequest, with: .success(user))
        await scenario.api.stubMessageRequest(for: AuthenticationToken("Token"), with: .success(messages))
        try await scenario.model.signIn(with: login)
        
        for message in messages {
            let entity = try scenario.model.message(identifiedBy: message.id)
            message.assert(against: entity)
        }
    }
    
    func testAfterSigningOutMessagesAreRemovedFromContext() async throws {
        let scenario = EurofurenceModelTestBuilder().with(keychain: UnauthenticatedKeychain()).build()
        let login = Login(registrationNumber: 42, username: "Some Guy", password: "p455w0rd")
        let loginRequest = LoginRequest(registrationNumber: 42, username: "Some Guy", password: "p455w0rd")
        let user = AuthenticatedUser(
            userIdentifier: 42,
            username: "Some Guy",
            token: "Token",
            tokenExpires: .distantFuture
        )
        
        let logoutRequest = LogoutRequest(
            authenticationToken: AuthenticationToken("Token"),
            pushNotificationDeviceToken: nil
        )
        
        let (received, read) = (Date(), Date())
        let messages = [
            EurofurenceWebAPI.Message(
                id: "Identifier",
                author: "Author",
                subject: "Subject",
                message: "Message",
                receivedDate: received,
                readDate: read
            )
        ]
        
        await scenario.api.stubLoginAttempt(loginRequest, with: .success(user))
        await scenario.api.stubMessageRequest(for: AuthenticationToken("Token"), with: .success(messages))
        await scenario.api.stubLogoutRequest(logoutRequest, with: .success(()))
        try await scenario.model.signIn(with: login)
        try await scenario.model.signOut()
        
        XCTAssertThrowsSpecificError(EurofurenceError.invalidMessage("Identifier")) {
            _ = try scenario.model.message(identifiedBy: "Identifier")
        }
    }
    
    func testWhenSignedInFutureReloadsIncludeMessages() async throws {
        
    }
    
    func testLoadingSameMessageMultipleTimesDoesNotDuplicateMessageInContext() async throws {
        
    }
    
    func testWhenSignedInAndCredentialIsNoLongerValid_MessagesAreRemovedFromContext() async throws {
        
    }

}
