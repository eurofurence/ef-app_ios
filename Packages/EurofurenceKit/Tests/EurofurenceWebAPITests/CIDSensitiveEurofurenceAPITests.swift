@testable import EurofurenceWebAPI
import XCTAsyncAssertions
import XCTest

class CIDSensitiveEurofurenceAPITests: XCTestCase {
    
    private var api: EurofurenceAPI!
    private var network: FakeNetwork!
    private var pushNotificationService: SpyPushNotificationService!
    private var configuration: CIDSensitiveEurofurenceAPI.Configuration!
    
    override func setUp() async throws {
        try await super.setUp()
        
        network = FakeNetwork()
        pushNotificationService = SpyPushNotificationService()
        configuration = CIDSensitiveEurofurenceAPI.Configuration(
            conventionIdentifier: "EF26",
            hostVersion: "4.0.0",
            network: network,
            pushNotificationService: pushNotificationService
        )
        
        api = CIDSensitiveEurofurenceAPI(configuration: configuration)
    }
    
    func testSyncWithoutTimestampUsesExpectedURL() async throws {
        let expectedURL = try XCTUnwrap(URL(string: "https://app.eurofurence.org/EF26/api/Sync"))
        let expectedRequest = NetworkRequest(url: expectedURL, method: .get)
        let responseFileData = try stubbedBody(fromJSONFileNamed: "EF26FullSyncResponse")
        network.stub(expectedRequest, with: .success(responseFileData))
        _ = try await api.execute(request: APIRequests.FetchLatestChanges(since: nil))
        
        let expected = FakeNetwork.Event.request(url: expectedURL)
        XCTAssertEqual([expected], network.history)
    }
    
    func testSyncWithTimestampUsesExpectedURL() async throws {
        let lastSyncTime = Date()
        let generationToken = SynchronizationPayload.GenerationToken(lastSyncTime: lastSyncTime)
        let formattedSyncTime = EurofurenceISO8601DateFormatter.instance.string(from: lastSyncTime)
        let expectedURLString = "https://app.eurofurence.org/EF26/api/Sync?since=\(formattedSyncTime)"
        let expectedURL = try XCTUnwrap(URL(string: expectedURLString))
        let expectedRequest = NetworkRequest(url: expectedURL, method: .get)
        let responseFileData = try stubbedBody(fromJSONFileNamed: "EF26FullSyncResponse")
        network.stub(expectedRequest, with: .success(responseFileData))
        _ = try await api.execute(request: APIRequests.FetchLatestChanges(since: generationToken))
        
        let expected = FakeNetwork.Event.request(url: expectedURL)
        XCTAssertEqual([expected], network.history)
    }
    
    func testDownloadingImageSuccess_WritesDataToURL() async throws {
        let temporaryFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("Image")
        
        addTeardownBlock {
            try FileManager.default.removeItem(at: temporaryFileURL)
        }
        
        let expectedImageEndpointString = "https://app.eurofurence.org/EF26/api/Images/ID/Content/with-hash:SHA"
        let expectedImageEndpoint = try XCTUnwrap(URL(string: expectedImageEndpointString))
        let expectedImageRequest = NetworkRequest(url: expectedImageEndpoint, method: .get)
        let pretendImageData = try XCTUnwrap("🎆".data(using: .utf8))
        network.stubDownload(of: expectedImageRequest, with: .success(pretendImageData))
        
        try await api.execute(request: APIRequests.DownloadImage(
            imageIdentifier: "ID",
            lastKnownImageContentHashSHA1: "SHA",
            downloadDestinationURL: temporaryFileURL
        ))
        
        let downloadedImageData = try Data(contentsOf: temporaryFileURL)
        XCTAssertEqual(downloadedImageData, pretendImageData)
    }
    
    func testDownloadingImageSuccess_FileAlreadyExists_NewImageOverwritesOldFile() async throws {
        let temporaryFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("Image")
        
        addTeardownBlock {
            try FileManager.default.removeItem(at: temporaryFileURL)
        }
        
        let imageRequest = APIRequests.DownloadImage(
            imageIdentifier: "ID",
            lastKnownImageContentHashSHA1: "SHA",
            downloadDestinationURL: temporaryFileURL
        )
        
        let existingData = try XCTUnwrap("👀".data(using: .utf8))
        try existingData.write(to: temporaryFileURL)
        
        let expectedImageEndpointString = "https://app.eurofurence.org/EF26/api/Images/ID/Content/with-hash:SHA"
        let expectedImageEndpoint = try XCTUnwrap(URL(string: expectedImageEndpointString))
        let expectedImageRequest = NetworkRequest(url: expectedImageEndpoint, method: .get)
        let pretendImageData = try XCTUnwrap("🎆".data(using: .utf8))
        network.stubDownload(of: expectedImageRequest, with: .success(pretendImageData))
        try await api.execute(request: imageRequest)
        
        let downloadedImageData = try Data(contentsOf: temporaryFileURL)
        XCTAssertEqual(downloadedImageData, pretendImageData)
    }
    
    func testSignIn_Success() async throws {
        let login = APIRequests.Login(registrationNumber: 42, username: "Some Guy", password: "p4s5w0rd")
        let expectedURLString = "https://app.eurofurence.org/EF26/api/Tokens/RegSys"
        let expectedURL = try XCTUnwrap(URL(string: expectedURLString))
        
        let expectedBodyData = try stubbedBody(fromJSONFileNamed: "ExpectedLoginBody")
        let expectedRequest = NetworkRequest(url: expectedURL, body: expectedBodyData, method: .post)
        
        let expectedResponseData = try stubbedBody(fromJSONFileNamed: "ExpectedSuccessfulLoginBody")
        network.stub(expectedRequest, with: .success(expectedResponseData))
        
        let authenticatedUser = try await api.execute(request: login)
        let formatter = EurofurenceISO8601DateFormatter.instance
        let expirationDate = try XCTUnwrap(formatter.date(from: "2022-09-04T21:23:36.780Z"))
        let expectedUser = AuthenticatedUser(
            userIdentifier: 108,
            username: "Username",
            token: "Token",
            tokenExpires: expirationDate
        )
        
        XCTAssertEqual(expectedUser, authenticatedUser)
    }
    
    func testRegisteringPushNotificationDeviceToken_Success() async throws {
        let authenticationToken = AuthenticationToken("Authentication Token")
        let pushNotificationDeviceTokenData = try XCTUnwrap("Push Token".data(using: .utf8))
        let pushRegistration = APIRequests.RegisterPushNotificationDeviceToken(
            authenticationToken: authenticationToken,
            pushNotificationDeviceToken: pushNotificationDeviceTokenData
        )
        
        let expectedURLString = "https://app.eurofurence.org/EF26/api/PushNotifications/FcmDeviceRegistration"
        let expectedURL = try XCTUnwrap(URL(string: expectedURLString))
        
        let expectedBodyData = try stubbedBody(fromJSONFileNamed: "ExpectedPushRegistrationBody")
        let expectedRequest = NetworkRequest(url: expectedURL, body: expectedBodyData, method: .post, headers: [
            "Authorization": "Bearer Authentication Token"
        ])
        
        network.stub(expectedRequest, with: .success(Data()))
        
        await XCTAssertEventuallyNoThrows {
            try await api.execute(request: pushRegistration)
        }
        
        let expectedNotificationServiceRegistration = PushNotificationServiceRegistration(
            pushNotificationDeviceTokenData: pushNotificationDeviceTokenData,
            channels: ["EF26", "EF26-ios"]
        )
        
        XCTAssertEqual(expectedNotificationServiceRegistration, pushNotificationService.registration)
    }
    
    func testRegisteringPushNotificationDeviceToken_NotLoggedIn_DoesNotIncludeAuthorizationHeader() async throws {
        let pushNotificationDeviceTokenData = try XCTUnwrap("Push Token".data(using: .utf8))
        let pushRegistration = APIRequests.RegisterPushNotificationDeviceToken(
            authenticationToken: nil,
            pushNotificationDeviceToken: pushNotificationDeviceTokenData
        )
        
        let expectedURLString = "https://app.eurofurence.org/EF26/api/PushNotifications/FcmDeviceRegistration"
        let expectedURL = try XCTUnwrap(URL(string: expectedURLString))
        
        let expectedBodyData = try stubbedBody(fromJSONFileNamed: "ExpectedPushRegistrationBody")
        let expectedRequest = NetworkRequest(url: expectedURL, body: expectedBodyData, method: .post)
        
        network.stub(expectedRequest, with: .success(Data()))
        
        await XCTAssertEventuallyNoThrows {
            try await api.execute(request: pushRegistration)
        }
        
        let expectedNotificationServiceRegistration = PushNotificationServiceRegistration(
            pushNotificationDeviceTokenData: pushNotificationDeviceTokenData,
            channels: ["EF26", "EF26-ios"]
        )
        
        XCTAssertEqual(expectedNotificationServiceRegistration, pushNotificationService.registration)
    }
    
    func testRegisteringPushNotificationDeviceToken_Failure() async throws {
        let authenticationToken = AuthenticationToken("Authentication Token")
        let pushNotificationDeviceTokenData = try XCTUnwrap("Push Token".data(using: .utf8))
        let pushRegistration = APIRequests.RegisterPushNotificationDeviceToken(
            authenticationToken: authenticationToken,
            pushNotificationDeviceToken: pushNotificationDeviceTokenData
        )
        
        let expectedURLString = "https://app.eurofurence.org/EF26/api/PushNotifications/FcmDeviceRegistration"
        let expectedURL = try XCTUnwrap(URL(string: expectedURLString))
        
        let expectedBodyData = try stubbedBody(fromJSONFileNamed: "ExpectedPushRegistrationBody")
        let expectedRequest = NetworkRequest(url: expectedURL, body: expectedBodyData, method: .post, headers: [
            "Authorization": "Bearer Authentication Token"
        ])
        
        let error = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        network.stub(expectedRequest, with: .failure(error))
        
        await XCTAssertEventuallyThrowsError {
            try await api.execute(request: pushRegistration)
        }
    }
    
    func testLoggingOut_Succeeds() async throws {
        let pushNotificationDeviceTokenData = try XCTUnwrap("Push Token".data(using: .utf8))
        let logout = APIRequests.Logout(
            pushNotificationDeviceToken: pushNotificationDeviceTokenData
        )
        
        let expectedURLString = "https://app.eurofurence.org/EF26/api/PushNotifications/FcmDeviceRegistration"
        let expectedURL = try XCTUnwrap(URL(string: expectedURLString))
        
        let expectedBodyData = try stubbedBody(fromJSONFileNamed: "ExpectedPushRegistrationBody")
        let expectedRequest = NetworkRequest(url: expectedURL, body: expectedBodyData, method: .post)
        
        network.stub(expectedRequest, with: .success(Data()))
        
        await XCTAssertEventuallyNoThrows { try await api.execute(request: logout) }
        
        let expectedNotificationServiceRegistration = PushNotificationServiceRegistration(
            pushNotificationDeviceTokenData: pushNotificationDeviceTokenData,
            channels: ["EF26", "EF26-ios"]
        )
        
        XCTAssertEqual(expectedNotificationServiceRegistration, pushNotificationService.registration)
    }
    
    func testLoggingOut_Fails() async throws {
        let pushNotificationDeviceTokenData = try XCTUnwrap("Push Token".data(using: .utf8))
        let logout = APIRequests.Logout(
            pushNotificationDeviceToken: pushNotificationDeviceTokenData
        )
        
        let expectedURLString = "https://app.eurofurence.org/EF26/api/PushNotifications/FcmDeviceRegistration"
        let expectedURL = try XCTUnwrap(URL(string: expectedURLString))
        
        let expectedBodyData = try stubbedBody(fromJSONFileNamed: "ExpectedPushRegistrationBody")
        let expectedRequest = NetworkRequest(url: expectedURL, body: expectedBodyData, method: .post)
        
        let error = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        network.stub(expectedRequest, with: .failure(error))
        
        await XCTAssertEventuallyThrowsError { try await api.execute(request: logout) }
        
        let expectedNotificationServiceRegistration = PushNotificationServiceRegistration(
            pushNotificationDeviceTokenData: pushNotificationDeviceTokenData,
            channels: ["EF26", "EF26-ios"]
        )
        
        XCTAssertEqual(expectedNotificationServiceRegistration, pushNotificationService.registration)
    }
    
    func testFetchingMessages() async throws {
        let authenticationToken = AuthenticationToken("Authentication Token")
        let expectedURLString = "https://app.eurofurence.org/EF26/api/Communication/PrivateMessages"
        let expectedURL = try XCTUnwrap(URL(string: expectedURLString))
        let expectedRequest = NetworkRequest(url: expectedURL, method: .get, headers: [
            "Authorization": "Bearer Authentication Token"
        ])
        
        let messagesResponse = try stubbedBody(fromJSONFileNamed: "ExpectedMessagesResponse")
        network.stub(expectedRequest, with: .success(messagesResponse))
        
        let request = APIRequests.FetchMessages(authenticationToken: authenticationToken)
        let messages = try await api.execute(request: request)
        let message = try XCTUnwrap(messages.first)
        let formatter = EurofurenceISO8601DateFormatter.instance
        let expectedReceived = try XCTUnwrap(formatter.date(from: "2017-07-25T18:45:59.050Z"))
        let expectedRead = try XCTUnwrap(formatter.date(from: "2017-07-25T18:50:59.050Z"))
        
        XCTAssertEqual(message.id, "ID")
        XCTAssertEqual(message.author, "Author")
        XCTAssertEqual(message.subject, "Subject")
        XCTAssertEqual(message.message, "Message")
        XCTAssertEqual(message.receivedDate, expectedReceived)
        XCTAssertEqual(message.readDate, expectedRead)
    }
    
    func testMarkingMessageAsReadSucceedsWhenNetworkDoesNotProduceError() async throws {
        let authenticationToken = AuthenticationToken("Authentication Token")
        let expectedURLString = "https://app.eurofurence.org/EF26/api/Communication/PrivateMessages/ID/Read"
        let expectedURL = try XCTUnwrap(URL(string: expectedURLString))
        let expectedBody = try XCTUnwrap("true".data(using: .utf8))
        let expectedRequest = NetworkRequest(url: expectedURL, body: expectedBody, method: .post, headers: [
            "Authorization": "Bearer Authentication Token"
        ])
        
        network.stub(expectedRequest, with: .success(Data()))
        
        let request = APIRequests.AcknowledgeMessage(authenticationToken: authenticationToken, messageIdentifier: "ID")
        await XCTAssertEventuallyNoThrows { try await api.execute(request: request) }
    }
    
    func testMarkingMessageAsReadFailsWhenNetworkProducesError() async throws {
        let authenticationToken = AuthenticationToken("Authentication Token")
        let expectedURLString = "https://app.eurofurence.org/EF26/api/Communication/PrivateMessages/ID/Read"
        let expectedURL = try XCTUnwrap(URL(string: expectedURLString))
        let expectedBody = try XCTUnwrap("true".data(using: .utf8))
        let expectedRequest = NetworkRequest(url: expectedURL, body: expectedBody, method: .post, headers: [
            "Authorization": "Bearer Authentication Token"
        ])
        
        let error = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        network.stub(expectedRequest, with: .failure(error))
        
        let request = APIRequests.AcknowledgeMessage(authenticationToken: authenticationToken, messageIdentifier: "ID")
        await XCTAssertEventuallyThrowsError { try await api.execute(request: request) }
    }
    
    func testSubmittingEventFeedbackSuccessfully() async throws {
        let expectedURLString = "https://app.eurofurence.org/EF26/api/EventFeedback"
        let expectedURL = try XCTUnwrap(URL(string: expectedURLString))
        let expectedBody = try stubbedBody(fromJSONFileNamed: "ExpectedEventFeedbackBody")
        let expectedRequest = NetworkRequest(url: expectedURL, body: expectedBody, method: .post)
        
        let feedbackRequest = APIRequests.SubmitEventFeedback(
            identifier: "ID",
            rating: 5,
            additionalComments: "Comments"
        )
        
        network.stub(expectedRequest, with: .success(Data()))
        
        await XCTAssertEventuallyNoThrows { try await api.execute(request: feedbackRequest) }
    }
    
    func testSubmittingEventFeedbackUnsuccessfully() async throws {
        let expectedURLString = "https://app.eurofurence.org/EF26/api/EventFeedback"
        let expectedURL = try XCTUnwrap(URL(string: expectedURLString))
        let expectedBody = try stubbedBody(fromJSONFileNamed: "ExpectedEventFeedbackBody")
        let expectedRequest = NetworkRequest(url: expectedURL, body: expectedBody, method: .post)
        
        let feedbackRequest = APIRequests.SubmitEventFeedback(
            identifier: "ID",
            rating: 5,
            additionalComments: "Comments"
        )
        
        let error = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        network.stub(expectedRequest, with: .failure(error))
        
        await XCTAssertEventuallyThrowsError { try await api.execute(request: feedbackRequest) }
    }
    
    private func stubbedBody(fromJSONFileNamed fileName: String) throws -> Data {
        let url = try XCTUnwrap(Bundle.module.url(forResource: fileName, withExtension: "json"))
        let data = try Data(contentsOf: url)
        let string = try XCTUnwrap(String(data: data, encoding: .utf8))
        
        // Xcode has a habit of appending a newline at the end of stubbed responses. This usually isn't a big deal,
        // except our assertions are checking we send the same body.
        let trimmedBody = string.trimmingCharacters(in: .newlines)
        return try XCTUnwrap(trimmedBody.data(using: .utf8))
    }

}
