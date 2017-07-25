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
    
    private(set) var wasNotifiedResponseFailed = false
    func handle(_ response: APIResponse<APIPrivateMessagesResponse>) {
        switch response {
        case .success(_):
            break
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
        let observer = makeCapturingObserverForResponse("[{ \"key\": \"value\" }]")
        XCTAssertTrue(observer.wasNotifiedResponseFailed)
    }
    
}
