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
        let jsonPoster = CapturingJSONPoster()
        let api = V2PrivateMessagesAPI(jsonPoster: jsonPoster)
        let observer = CapturingV2PrivateMessagesObserver()
        api.loadPrivateMessages(authorizationToken: "", completionHandler: observer.handle)
        jsonPoster.invokeLastCompletionHandler(responseData: nil)
        
        XCTAssertTrue(observer.wasNotifiedResponseFailed)
    }
    
    func testResponseProvidesNonJSONDataShouldProvideFailureRespone() {
        let jsonPoster = CapturingJSONPoster()
        let api = V2PrivateMessagesAPI(jsonPoster: jsonPoster)
        let observer = CapturingV2PrivateMessagesObserver()
        api.loadPrivateMessages(authorizationToken: "", completionHandler: observer.handle)
        let data = "Not json!".data(using: .utf8)!
        jsonPoster.invokeLastCompletionHandler(responseData: data)
        
        XCTAssertTrue(observer.wasNotifiedResponseFailed)
    }
    
    func testResponseProvidesWrongRootStructureShouldProvideFailureResponse() {
        let jsonPoster = CapturingJSONPoster()
        let api = V2PrivateMessagesAPI(jsonPoster: jsonPoster)
        let observer = CapturingV2PrivateMessagesObserver()
        api.loadPrivateMessages(authorizationToken: "", completionHandler: observer.handle)
        let data = "[{ \"key\": \"value\" }]".data(using: .utf8)!
        jsonPoster.invokeLastCompletionHandler(responseData: data)
        
        XCTAssertTrue(observer.wasNotifiedResponseFailed)
    }
    
}
