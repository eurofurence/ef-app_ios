//
//  ImageAPITests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import TestUtilities
import XCTest

class ImageAPITests: XCTestCase {

    func testSubmitsExpectedURL() {
        let identifier = String.random
        let apiUrl = StubAPIURLProviding()
        let expected = URL(string: apiUrl.url + "Images/\(identifier)/Content")!.absoluteString
        let jsonSession = CapturingJSONSession()
        let api = JSONAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        api.fetchImage(identifier: identifier) { (_) in }

        XCTAssertEqual(expected, jsonSession.getRequestURL)
    }

    func testProvidesDataFromRequest() {
        let jsonSession = CapturingJSONSession()
        let apiUrl = StubAPIURLProviding()
        let api = JSONAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        let expected = Data.random
        var actual: Data?
        api.fetchImage(identifier: .random) { actual = $0 }
        jsonSession.invokeLastGETCompletionHandler(responseData: expected)

        XCTAssertEqual(expected, actual)
    }

}
