//
//  EurofurenceFCMDeviceRegistrationTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Eurofurence
import EurofurenceModelTestDoubles
import XCTest

class EurofurenceFCMDeviceRegistrationTests: XCTestCase {

    var capturingJSONSession: CapturingJSONSession!
    var registration: EurofurenceFCMDeviceRegistration!
    var urlProviding: StubV2ApiUrlProviding!

    override func setUp() {
        super.setUp()

        capturingJSONSession = CapturingJSONSession()
        urlProviding = StubV2ApiUrlProviding()
        registration = EurofurenceFCMDeviceRegistration(JSONSession: capturingJSONSession, urlProviding: urlProviding)
    }

    private func performRegistration(_ fcm: String = "",
                                     topics: [FirebaseTopic] = [],
                                     authenticationToken: String? = "",
                                     completionHandler: ((Error?) -> Void)? = nil) {
        registration.registerFCM(fcm, topics: topics, authenticationToken: authenticationToken) { completionHandler?($0) }
    }

    func testRegisteringTheFCMTokenSubmitsRequestToFCMRegistrationURL() {
        performRegistration()
        let expectedURL = urlProviding.url + "PushNotifications/FcmDeviceRegistration"

        XCTAssertEqual(expectedURL, capturingJSONSession.postedURL)
    }

    func testRegisteringTheFCMTokenShouldNotSubmitRequestUntilRegistrationActuallyOccurs() {
        XCTAssertNil(capturingJSONSession.postedURL)
    }

    func testRegisteringTheFCMTokenShouldPostJSONBodyWithDeviceIDAsFCMToken() {
        let fcm = "Something unique"
        performRegistration(fcm)

        XCTAssertEqual(fcm, capturingJSONSession.postedJSONValue(forKey: "DeviceId"))
    }

    func testRegisteringTheFCMTokenShouldSupplyTheLiveTopicWithinAnArrayUnderTheTopicsKey() {
        let topic = FirebaseTopic.live
        performRegistration(topics: [topic])
        let expected: [String] = [topic.description]

        XCTAssertEqual(expected, capturingJSONSession.postedJSONValue(forKey: "Topics") ?? [])
    }

    func testRegisteringTheFCMTokenShouldSupplyTheTestTopicWithinAnArrayUnderTheTopicsKey() {
        let topic = FirebaseTopic.test
        performRegistration(topics: [topic])
        let expected: [String] = [topic.description]

        XCTAssertEqual(expected, capturingJSONSession.postedJSONValue(forKey: "Topics") ?? [])
    }

    func testRegisteringTheFCMTokenShouldSupplyAllTopicsWithinAnArrayUnderTheTopicsKey() {
        let topics: [FirebaseTopic] = [.test, .live]
        performRegistration(topics: topics)
        let expected: [String] = topics.map({ $0.description })

        XCTAssertEqual(expected, capturingJSONSession.postedJSONValue(forKey: "Topics") ?? [])
    }

    func testRegisteringTheFCMTokenWithUserAuthenticationTokenSuppliesItUsingTheAuthHeader() {
        let authenticationToken = "Token"
        performRegistration(authenticationToken: authenticationToken)

        XCTAssertEqual("Bearer \(authenticationToken)", capturingJSONSession.capturedAdditionalPOSTHeaders?["Authorization"])
    }

    func testRegisteringTheFCMTokenWithoutUserAuthenticationTokenDoesNotSupplyAuthHeader() {
        performRegistration(authenticationToken: nil)
        XCTAssertNil(capturingJSONSession.capturedAdditionalPOSTHeaders?["Authorization"])
    }

    func testFailingToRegisterFCMTokenPropagatesErrorToCompletionHandler() {
        let expectedError = NSError(domain: "Test", code: 0, userInfo: nil)
        var observedError: NSError?
        performRegistration { observedError = $0! as NSError }
        capturingJSONSession.invokeLastPOSTCompletionHandler(responseData: nil, error: expectedError)

        XCTAssertEqual(expectedError, observedError)
    }

}
