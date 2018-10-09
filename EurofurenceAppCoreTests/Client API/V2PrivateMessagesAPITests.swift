//
//  V2PrivateMessagesAPITests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class CapturingV2PrivateMessagesObserver {
    
    private(set) var wasNotifiedResponseSucceeded = false
    private(set) var wasNotifiedResponseFailed = false
    private(set) var capturedMessages: [Message]?
    func handle(_ messages: [Message]?) {
        if let messages = messages {
            wasNotifiedResponseSucceeded = true
            capturedMessages = messages
        }
        else {
            wasNotifiedResponseFailed = true
        }
    }
    
}

class V2PrivateMessagesAPITests: XCTestCase {
    
    var JSONSession: CapturingJSONSession!
    var api: V2PrivateMessagesAPI!
    var apiUrl: V2ApiUrlProviding!
    
    override func setUp() {
        super.setUp()
        
        JSONSession = CapturingJSONSession()
        apiUrl = StubV2ApiUrlProviding()
        api = V2PrivateMessagesAPI(jsonSession: JSONSession, apiUrl: apiUrl)
    }
    
    private func makeCapturingObserverForResponse(_ response: String?) -> CapturingV2PrivateMessagesObserver {
        let observer = CapturingV2PrivateMessagesObserver()
        api.loadPrivateMessages(authorizationToken: "", completionHandler: observer.handle)
        JSONSession.invokeLastGETCompletionHandler(responseData: response?.data(using: .utf8))
        
        return observer
    }
    
    private func makeSuccessfulResponse(id: String = "ID",
                                        authorName: String = "Author",
                                        subject: String = "Subject",
                                        message: String = "Message",
                                        recipientUid: String = "Recipient",
                                        lastChangeDateTime: String = "2017-07-25T18:45:59.050Z",
                                        createdDateTime: String = "2017-07-25T18:45:59.050Z",
                                        receivedDateTime: String = "2017-07-25T18:45:59.050Z",
                                        readDateTime: String = "2017-07-25T18:45:59.050Z") -> String {
        return "[" +
        "{" +
            "\"LastChangeDateTimeUtc\": \"\(lastChangeDateTime)\"," +
            "\"Id\": \"\(id)\"," +
            "\"RecipientUid\": \"\(recipientUid)\"," +
            "\"CreatedDateTimeUtc\": \"\(createdDateTime)\"," +
            "\"ReceivedDateTimeUtc\": \"\(receivedDateTime)\"," +
            "\"ReadDateTimeUtc\": \"\(readDateTime)\"," +
            "\"AuthorName\": \"\(authorName)\"," +
            "\"Subject\": \"\(subject)\"," +
            "\"Message\": \"\(message)\"" +
        "}" +
        "]"
    }
    
    func testThePrivateMessagesEndpointShouldReceieveRequest() {
        let expectedURL = apiUrl.url + "Communication/PrivateMessages"
        api.loadPrivateMessages(authorizationToken: "", completionHandler: { _ in } )
        
        XCTAssertEqual(expectedURL, JSONSession.getRequestURL)
    }
    
    func testTheAuthorizationTokenShouldBeMadeAvailableInTheAuthorizationHeader() {
        let token = "Top secret"
        api.loadPrivateMessages(authorizationToken: token, completionHandler: { _ in } )
        
        XCTAssertEqual("Bearer \(token)", JSONSession.capturedAdditionalGETHeaders?["Authorization"])
    }
    
    func testResponseProvidesNilDataShouldProvideFailureResponse() {
        let observer = makeCapturingObserverForResponse(nil)
        XCTAssertTrue(observer.wasNotifiedResponseFailed)
    }
    
    func testResponseProvidesNonJSONDataShouldProvideFailureRespone() {
        let observer = makeCapturingObserverForResponse("Not json!")
        XCTAssertTrue(observer.wasNotifiedResponseFailed)
    }
    
    func testResponseProvidesWrongRootStructureShouldProvideFailureResponse() {
        let observer = makeCapturingObserverForResponse("{ \"key\": \"value\" }")
        XCTAssertTrue(observer.wasNotifiedResponseFailed)
    }
    
    func testResponseProvidesExpectedStructureShouldReturnSuccessfulResponse() {
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse())
        XCTAssertTrue(observer.wasNotifiedResponseSucceeded)
    }
    
    func testSuccessfulResponseShouldProvideMessageWithIdentifier() {
        let identifier = "Some identifier"
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(id: identifier))
        
        XCTAssertEqual(identifier, observer.capturedMessages?.first?.identifier)
    }
    
    func testSuccessfulResponseShouldProvideMessageWithAuthorName() {
        let authorName = "Some author"
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(authorName: authorName))
        
        XCTAssertEqual(authorName, observer.capturedMessages?.first?.authorName)
    }
    
    func testSuccessfulResponseShouldProvideMessageWithSubject() {
        let subject = "Some subject"
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(subject: subject))
        
        XCTAssertEqual(subject, observer.capturedMessages?.first?.subject)
    }
    
    func testSuccessfulResponseShouldProvideMessageWithItsContent() {
        let message = "Some content"
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(message: message))
        
        XCTAssertEqual(message, observer.capturedMessages?.first?.contents)
    }
    
    func testSuccessfulResponseWithUnsupportedreceivedDateTimeValueShouldProvideFailureResponse() {
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(receivedDateTime: "Not a date"))
        XCTAssertTrue(observer.wasNotifiedResponseFailed)
    }
    
    func testSuccessfulResponseWithSupportedreceivedDateTimeValueShouldProvidereceivedDateTime() {
        let dateString =  "2017-07-25T18:45:59.050Z"
        let expectedComponents = DateComponents(year: 2017, month: 7, day: 25, hour: 18, minute: 45, second: 59)
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(receivedDateTime: dateString))
        
        var actualComponents: DateComponents?
        if let receievedDate = observer.capturedMessages?.first?.receivedDateTime {
            let desiredComponents: [Calendar.Component] = [.year, .month, .day, .hour, .minute, .second]
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(abbreviation: "GMT")!
            actualComponents = calendar.dateComponents(Set(desiredComponents), from: receievedDate)
        }
        
        XCTAssertEqual(expectedComponents, actualComponents)
    }
    
    func testSuccessfulResponseWithUnsupportedReadDateTimeValueShouldNotProvideFailureResponse() {
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(readDateTime: "Not a date"))
        XCTAssertFalse(observer.wasNotifiedResponseFailed)
    }
    
    func testSuccessfulResponseWithUnsupportedReadDateTimeValueShouldIndicateUnread() {
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(readDateTime: "Not a date"))
        XCTAssertEqual(false, observer.capturedMessages?.first?.isRead)
    }
    
    func testSuccessfulResponseWithSupportedReadDateTimeValueShouldIndicateIsRead() {
        let dateString =  "2017-07-25T18:45:59.050Z"
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(receivedDateTime: dateString))
        
        XCTAssertEqual(true, observer.capturedMessages?.first?.isRead)
    }
    
    func testMarkingAPIMessageAsReadSubmitsPOSTRequestToMessageReadURL() {
        let identifier = "Test"
        api.markMessageWithIdentifierAsRead(identifier, authorizationToken: "")
        let expectedURL = apiUrl.url + "Communication/PrivateMessages/\(identifier)/Read"
        
        XCTAssertEqual(expectedURL, JSONSession.postedURL)
    }
    
    func testMarkingAPIMessageAsReadSubmitsProvidesTheAuthorizationTokenInTheAuthorizationHeader() {
        let token = "Top secret"
        api.markMessageWithIdentifierAsRead("", authorizationToken: token)
        
        XCTAssertEqual("Bearer \(token)", JSONSession.capturedAdditionalPOSTHeaders?["Authorization"])
    }
    
    // See issue #145
    func testMarkingAPIMessageAsReadSubmitsTrueWithinPOSTBodyToSupportSwaggerWorkaround() {
        let expected = "true".data(using: .utf8)!
        api.markMessageWithIdentifierAsRead("", authorizationToken: .random)
        
        XCTAssertEqual(expected, JSONSession.POSTData)
    }
    
}
