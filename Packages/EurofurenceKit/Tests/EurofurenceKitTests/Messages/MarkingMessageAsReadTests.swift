import CoreData
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTAsyncAssertions
import XCTest

class MarkingMessageAsReadTests: XCTestCase {
    
    func testMarkingUnreadMessageOnSuccessUpdatesLocalReadState() async throws {
        let api = FakeEurofurenceAPI()
        
        let received = Date()
        let messages = [
            EurofurenceWebAPI.Message(
                id: "Identifier",
                author: "Author",
                subject: "Subject",
                message: "Message",
                receivedDate: received,
                readDate: nil
            )
        ]
        
        let authenticationToken = AuthenticationToken("ABC")
        await api.stubMessageRequest(for: authenticationToken, with: .success(messages))
        let scenario = await EurofurenceModelTestBuilder()
            .with(keychain: AuthenticatedKeychain())
            .with(api: api)
            .build()
        
        try await scenario.updateLocalStore(using: .ef26)
        
        let message = try scenario.model.message(identifiedBy: "Identifier")
        
        XCTAssertFalse(
            message.isRead,
            "Messages not marked as read should indicate so in the persistent store"
        )
        
        let expectedRequest = AcknowledgeMessageRequest(
            authenticationToken: authenticationToken,
            messageIdentifier: "Identifier"
        )
        
        await api.stubMessageReadRequest(for: expectedRequest, with: .success(()))
        await message.markRead()
        
        XCTAssertTrue(
            message.isRead,
            "Messages marked as read should indicate so in the persistent store"
        )
    }
    
    func testSuccessfullyMarkingMessageAsReadDoesNotTryToMarkItReadAgain() async throws {
        let api = FakeEurofurenceAPI()
        
        let received = Date()
        let messages = [
            EurofurenceWebAPI.Message(
                id: "Identifier",
                author: "Author",
                subject: "Subject",
                message: "Message",
                receivedDate: received,
                readDate: nil
            )
        ]
        
        let authenticationToken = AuthenticationToken("ABC")
        await api.stubMessageRequest(for: authenticationToken, with: .success(messages))
        let scenario = await EurofurenceModelTestBuilder()
            .with(keychain: AuthenticatedKeychain())
            .with(api: api)
            .build()
        
        try await scenario.updateLocalStore(using: .ef26)
        
        let message = try scenario.model.message(identifiedBy: "Identifier")
        
        let expectedRequest = AcknowledgeMessageRequest(
            authenticationToken: authenticationToken,
            messageIdentifier: "Identifier"
        )
        
        await api.stubMessageReadRequest(for: expectedRequest, with: .success(()))
        await message.markRead()
        await message.markRead()
        
        let markedMessageReadyIdentifiers = await api.markedMessageReadIdentifiers
        XCTAssertEqual(
            ["Identifier"],
            markedMessageReadyIdentifiers,
            "Expected not to try and mark the same message as read multiple times"
        )
    }
    
    func testMarkingUnreadMessageOnFailureRequestsMessageMarkedAsReadOnNextSync() async throws {
        let api = FakeEurofurenceAPI()
        
        let received = Date()
        let messages = [
            EurofurenceWebAPI.Message(
                id: "Identifier",
                author: "Author",
                subject: "Subject",
                message: "Message",
                receivedDate: received,
                readDate: nil
            )
        ]
        
        let authenticationToken = AuthenticationToken("ABC")
        await api.stubMessageRequest(for: authenticationToken, with: .success(messages))
        let scenario = await EurofurenceModelTestBuilder()
            .with(keychain: AuthenticatedKeychain())
            .with(api: api)
            .build()
        
        try await scenario.updateLocalStore(using: .ef26)
        
        let message = try scenario.model.message(identifiedBy: "Identifier")

        let expectedRequest = AcknowledgeMessageRequest(
            authenticationToken: authenticationToken,
            messageIdentifier: "Identifier"
        )
        
        let error = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        await api.stubMessageReadRequest(for: expectedRequest, with: .failure(error))
        await message.markRead()
        
        // The previous attempt to mark the message as read failed. On the next sync, the model
        // should attempt to update the remote's state again.
        try await scenario.updateLocalStore(using: .noChanges)
        
        let markedMessageReadyIdentifiers = await api.markedMessageReadIdentifiers
        XCTAssertEqual(
            ["Identifier", "Identifier"],
            markedMessageReadyIdentifiers,
            "Expected to re-attempt marking the message as read during a sync when the first attempt failed"
        )
    }

}
