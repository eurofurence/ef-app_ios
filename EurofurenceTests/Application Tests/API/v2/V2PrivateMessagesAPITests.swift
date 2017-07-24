//
//  V2PrivateMessagesAPITests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

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
    
}
