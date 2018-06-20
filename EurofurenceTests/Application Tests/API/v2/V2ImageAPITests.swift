//
//  V2ImageAPITests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class V2ImageAPITests: XCTestCase {
    
    func testSubmitsExpectedURL() {
        let identifier = String.random
        let apiUrl = StubV2ApiUrlProviding()
        let expected = URL(string: apiUrl.url + "Images/\(identifier)/Content")!.absoluteString
        let jsonSession = CapturingJSONSession()
        let api = V2ImageAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        api.fetchImage(identifier: identifier) { (_) in }
        
        XCTAssertEqual(expected, jsonSession.getRequestURL)
    }
    
    func testProvidesDataFromRequest() {
        let jsonSession = CapturingJSONSession()
        let apiUrl = StubV2ApiUrlProviding()
        let api = V2ImageAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        let expected = Data.random
        var actual: Data?
        api.fetchImage(identifier: .random) { actual = $0 }
        jsonSession.invokeLastGETCompletionHandler(responseData: expected)
        
        XCTAssertEqual(expected, actual)
    }
    
}
