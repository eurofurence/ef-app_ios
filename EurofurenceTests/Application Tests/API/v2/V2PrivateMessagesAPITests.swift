//
//  V2PrivateMessagesAPITests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingV2PrivateMessagesObserver {
    
    private(set) var wasNotifiedResponseSucceeded = false
    private(set) var wasNotifiedResponseFailed = false
    private(set) var capturedMessages: [APIPrivateMessage]?
    func handle(_ response: APIResponse<APIPrivateMessagesResponse>) {
        switch response {
        case .success(let response):
            wasNotifiedResponseSucceeded = true
            capturedMessages = response.messages
            
        case .failure:
            wasNotifiedResponseFailed = true
        }
    }
    
}

class V2PrivateMessagesAPITests: XCTestCase {
    
    private func makeCapturingObserverForResponse(_ response: String?) -> CapturingV2PrivateMessagesObserver {
        let jsonPoster = CapturingJSONPoster()
        let api = V2PrivateMessagesAPI(jsonPoster: jsonPoster)
        let observer = CapturingV2PrivateMessagesObserver()
        api.loadPrivateMessages(authorizationToken: "", completionHandler: observer.handle)
        jsonPoster.invokeLastCompletionHandler(responseData: response?.data(using: .utf8))
        
        return observer
    }
    
    private func makeSuccessfulResponse(id: String = "ID",
                                        authorName: String = "Author",
                                        subject: String = "Subject",
                                        message: String = "Message",
                                        recipientUid: String = "Recipient",
                                        lastChangeDateTime: String = "2017-07-25T18:45:59.050Z",
                                        createdDateTime: String = "2017-07-25T18:45:59.050Z",
                                        receievedDateTime: String = "2017-07-25T18:45:59.050Z",
                                        readDateTime: String = "2017-07-25T18:45:59.050Z") -> String {
        return "[" +
        "{" +
            "\"LastChangeDateTimeUtc\": \"\(lastChangeDateTime)\"," +
            "\"Id\": \"\(id)\"," +
            "\"RecipientUid\": \"\(recipientUid)\"," +
            "\"CreatedDateTimeUtc\": \"\(createdDateTime)\"," +
            "\"ReceivedDateTimeUtc\": \"\(receievedDateTime)\"," +
            "\"ReadDateTimeUtc\": \"\(readDateTime)\"," +
            "\"AuthorName\": \"\(authorName)\"," +
            "\"Subject\": \"\(subject)\"," +
            "\"Message\": \"\(message)\"" +
        "}" +
        "]"
    }
    
    func testThePrivateMessagesEndpointShouldReceievePOSTRequest() {
        let expectedURL = "https://app.eurofurence.org/api/v2/Communication/PrivateMessages"
        let jsonPoster = CapturingJSONPoster()
        let api = V2PrivateMessagesAPI(jsonPoster: jsonPoster)
        api.loadPrivateMessages(authorizationToken: "", completionHandler: { _ in } )
        
        XCTAssertEqual(expectedURL, jsonPoster.postedURL)
    }
    
    func testTheAuthorizationTokenShouldBeMadeAvailableInTheAuthorizationHeader() {
        let jsonPoster = CapturingJSONPoster()
        let api = V2PrivateMessagesAPI(jsonPoster: jsonPoster)
        let token = "Top secret"
        api.loadPrivateMessages(authorizationToken: token, completionHandler: { _ in } )
        
        XCTAssertEqual("Bearer \(token)", jsonPoster.capturedAdditionalHeaders?["Authorization"])
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
        
        XCTAssertEqual(identifier, observer.capturedMessages?.first?.id)
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
        
        XCTAssertEqual(message, observer.capturedMessages?.first?.message)
    }
    
    func testSuccessfulResponseShouldProvideMessageWithRecipientIdentifier() {
        let recipientUid = "Some recepient"
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(recipientUid: recipientUid))
        
        XCTAssertEqual(recipientUid, observer.capturedMessages?.first?.recipientUid)
    }
    
    func testSuccessfulResponseWithUnsupportedLastChangeDateTimeValueShouldProvideFailureResponse() {
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(lastChangeDateTime: "Not a date"))
        XCTAssertTrue(observer.wasNotifiedResponseFailed)
    }
    
    func testSuccessfulResponseWithSupportedLastChangeDateTimeValueShouldProvideLastChangeDateTime() {
        let dateString =  "2017-07-25T18:45:59.050Z"
        let expectedComponents = DateComponents(year: 2017, month: 7, day: 25, hour: 18, minute: 45, second: 59)
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(lastChangeDateTime: dateString))
        
        var actualComponents: DateComponents?
        if let receievedDate = observer.capturedMessages?.first?.lastChangeDateTime {
            let desiredComponents: [Calendar.Component] = [.year, .month, .day, .hour, .minute, .second]
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(abbreviation: "GMT")!
            actualComponents = calendar.dateComponents(Set(desiredComponents), from: receievedDate)
        }
        
        XCTAssertEqual(expectedComponents, actualComponents)
    }
    
    func testSuccessfulResponseWithUnsupportedCreatedDateTimeValueShouldProvideFailureResponse() {
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(createdDateTime: "Not a date"))
        XCTAssertTrue(observer.wasNotifiedResponseFailed)
    }
    
    func testSuccessfulResponseWithSupportedCreatedDateTimeValueShouldProvideCreatedDateTime() {
        let dateString =  "2017-07-25T18:45:59.050Z"
        let expectedComponents = DateComponents(year: 2017, month: 7, day: 25, hour: 18, minute: 45, second: 59)
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(createdDateTime: dateString))
        
        var actualComponents: DateComponents?
        if let receievedDate = observer.capturedMessages?.first?.createdDateTime {
            let desiredComponents: [Calendar.Component] = [.year, .month, .day, .hour, .minute, .second]
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(abbreviation: "GMT")!
            actualComponents = calendar.dateComponents(Set(desiredComponents), from: receievedDate)
        }
        
        XCTAssertEqual(expectedComponents, actualComponents)
    }
    
    func testSuccessfulResponseWithUnsupportedReceievedDateTimeValueShouldProvideFailureResponse() {
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(receievedDateTime: "Not a date"))
        XCTAssertTrue(observer.wasNotifiedResponseFailed)
    }
    
    func testSuccessfulResponseWithSupportedReceievedDateTimeValueShouldProvideReceievedDateTime() {
        let dateString =  "2017-07-25T18:45:59.050Z"
        let expectedComponents = DateComponents(year: 2017, month: 7, day: 25, hour: 18, minute: 45, second: 59)
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(receievedDateTime: dateString))
        
        var actualComponents: DateComponents?
        if let receievedDate = observer.capturedMessages?.first?.receievedDateTime {
            let desiredComponents: [Calendar.Component] = [.year, .month, .day, .hour, .minute, .second]
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(abbreviation: "GMT")!
            actualComponents = calendar.dateComponents(Set(desiredComponents), from: receievedDate)
        }
        
        XCTAssertEqual(expectedComponents, actualComponents)
    }
    
    func testSuccessfulResponseWithUnsupportedReadDateTimeValueShouldProvideFailureResponse() {
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(readDateTime: "Not a date"))
        XCTAssertTrue(observer.wasNotifiedResponseFailed)
    }
    
    func testSuccessfulResponseWithSupportedReadDateTimeValueShouldProvideReadDateTime() {
        let dateString =  "2017-07-25T18:45:59.050Z"
        let expectedComponents = DateComponents(year: 2017, month: 7, day: 25, hour: 18, minute: 45, second: 59)
        let observer = makeCapturingObserverForResponse(makeSuccessfulResponse(receievedDateTime: dateString))
        
        var actualComponents: DateComponents?
        if let receievedDate = observer.capturedMessages?.first?.readDateTime {
            let desiredComponents: [Calendar.Component] = [.year, .month, .day, .hour, .minute, .second]
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(abbreviation: "GMT")!
            actualComponents = calendar.dateComponents(Set(desiredComponents), from: receievedDate)
        }
        
        XCTAssertEqual(expectedComponents, actualComponents)
    }
    
}
