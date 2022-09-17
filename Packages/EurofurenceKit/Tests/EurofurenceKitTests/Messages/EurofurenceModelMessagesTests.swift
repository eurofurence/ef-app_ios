import CoreData
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTAsyncAssertions
import XCTest

class EurofurenceModelMessagesTests: EurofurenceKitTestCase {
    
    func testWhenSignedInMessagesAreCachedIntoContext() async throws {
        let scenario = await EurofurenceModelTestBuilder().with(keychain: UnauthenticatedKeychain()).build()
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
        let scenario = await EurofurenceModelTestBuilder().with(keychain: UnauthenticatedKeychain()).build()
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
        
        XCTAssertThrowsSpecificError(
            EurofurenceError.invalidMessage("Identifier"),
            try scenario.model.message(identifiedBy: "Identifier")
        )
    }
    
    func testWhenSignedInFutureReloadsIncludeMessages() async throws {
        let scenario = await EurofurenceModelTestBuilder().with(keychain: UnauthenticatedKeychain()).build()
        let login = Login(registrationNumber: 42, username: "Some Guy", password: "p455w0rd")
        let loginRequest = LoginRequest(registrationNumber: 42, username: "Some Guy", password: "p455w0rd")
        let user = AuthenticatedUser(
            userIdentifier: 42,
            username: "Some Guy",
            token: "Token",
            tokenExpires: .distantFuture
        )
        
        await scenario.api.stubLoginAttempt(loginRequest, with: .success(user))
        try await scenario.model.signIn(with: login)
        
        // The next update should include a fetch for messages now we are authenticated.
        let (received, read) = (Date(), Date())
        let message = EurofurenceWebAPI.Message(
            id: "Identifier",
            author: "Author",
            subject: "Subject",
            message: "Message",
            receivedDate: received,
            readDate: read
        )
        
        await scenario.api.stubMessageRequest(for: AuthenticationToken("Token"), with: .success([message]))
        try await scenario.updateLocalStore(using: .ef26)
        
        let entity = try scenario.model.message(identifiedBy: "Identifier")
        message.assert(against: entity)
    }
    
    func testLoadingSameMessageMultipleTimesDoesNotDuplicateMessageInContext() async throws {
        let scenario = await EurofurenceModelTestBuilder().with(keychain: UnauthenticatedKeychain()).build()
        let login = Login(registrationNumber: 42, username: "Some Guy", password: "p455w0rd")
        let loginRequest = LoginRequest(registrationNumber: 42, username: "Some Guy", password: "p455w0rd")
        let user = AuthenticatedUser(
            userIdentifier: 42,
            username: "Some Guy",
            token: "Token",
            tokenExpires: .distantFuture
        )
        
        let (received, read) = (Date(), Date())
        let message = EurofurenceWebAPI.Message(
            id: "Identifier",
            author: "Author",
            subject: "Subject",
            message: "Message",
            receivedDate: received,
            readDate: read
        )
        
        await scenario.api.stubMessageRequest(for: AuthenticationToken("Token"), with: .success([message]))
        await scenario.api.stubLoginAttempt(loginRequest, with: .success(user))
        try await scenario.model.signIn(with: login)
        
        // The message already exists in the persistent store - there should only be one instance when fetching again.
        try await scenario.updateLocalStore(using: .ef26)
        
        let fetchRequest: NSFetchRequest<EurofurenceKit.Message> = EurofurenceKit.Message.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", "Identifier")
        fetchRequest.resultType = .countResultType
        
        let count = try scenario.viewContext.count(for: fetchRequest)
        XCTAssertEqual(1, count, "Only one instance of a message should exist in the store, based on its ID")
    }
    
    func testSignedIn_CredentialExpiresMidSession_DoesNotRequestMessagesDuringNextRefresh() async throws {
        let keychain = AuthenticatedKeychain()
        let scenario = await EurofurenceModelTestBuilder().with(keychain: keychain).build()
        
        var expiredCredental = try XCTUnwrap(keychain.credential)
        expiredCredental.tokenExpiryDate = .distantPast
        keychain.credential = expiredCredental
        
        let error = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        await scenario.api.stubMessageRequest(for: expiredCredental.authenticationToken, with: .failure(error))
        
        // The update should not fail as we should not attempt to request messages with an invalid token.
        await XCTAssertEventuallyNoThrows { try await scenario.updateLocalStore(using: .ef26) }
    }
    
    func testWhenSignedInAndCredentialIsNoLongerValid_MessagesAreRemovedFromContext() async throws {
        let keychain = AuthenticatedKeychain()
        let scenario = await EurofurenceModelTestBuilder().with(keychain: keychain).build()
        let (received, read) = (Date(), Date())
        let message = EurofurenceWebAPI.Message(
            id: "Identifier",
            author: "Author",
            subject: "Subject",
            message: "Message",
            receivedDate: received,
            readDate: read
        )
        
        var credental = try XCTUnwrap(keychain.credential)
        await scenario.api.stubMessageRequest(for: credental.authenticationToken, with: .success([message]))
        
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        await XCTAssertEventuallyNoThrows { try await scenario.updateLocalStore() }
        
        credental.tokenExpiryDate = .distantPast
        keychain.credential = credental
        
        let noChanges = try SampleResponse.noChanges.loadResponse()
        await scenario.stubSyncResponse(with: .success(noChanges), for: payload.synchronizationToken)
        
        await XCTAssertEventuallyNoThrows { try await scenario.updateLocalStore() }
        
        let fetchRequest: NSFetchRequest<EurofurenceKit.Message> = EurofurenceKit.Message.fetchRequest()
        fetchRequest.predicate = NSPredicate(value: true)
        fetchRequest.resultType = .countResultType
        
        let count = try scenario.viewContext.count(for: fetchRequest)
        XCTAssertEqual(0, count, "Messages should be removed from the persistent store on next refresh after sign-out")
    }

}
