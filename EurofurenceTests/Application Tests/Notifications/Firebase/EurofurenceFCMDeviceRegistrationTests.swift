//
//  EurofurenceFCMDeviceRegistrationTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class EurofurenceFCMDeviceRegistrationTests: XCTestCase {
    
    func testRegisteringTheFCMTokenSubmitsRequestToFCMRegistrationURL() {
        let capturingJSONSession = CapturingJSONSession()
        let registration = EurofurenceFCMDeviceRegistration(JSONSession: capturingJSONSession)
        registration.registerFCM("", topics: [], authenticationToken: "")
        let expectedURL = "https://app.eurofurence.org/api/v2/PushNotifications/FcmDeviceRegistration"

        XCTAssertEqual(expectedURL, capturingJSONSession.postedURL)
    }

    func testRegisteringTheFCMTokenShouldNotSubmitRequestUntilRegistrationActuallyOccurs() {
        let capturingJSONSession = CapturingJSONSession()
        _ = EurofurenceFCMDeviceRegistration(JSONSession: capturingJSONSession)

        XCTAssertNil(capturingJSONSession.postedURL)
    }

    func testRegisteringTheFCMTokenShouldPostJSONBodyWithDeviceIDAsFCMToken() {
        let capturingJSONSession = CapturingJSONSession()
        let registration = EurofurenceFCMDeviceRegistration(JSONSession: capturingJSONSession)
        let fcm = "Something unique"
        registration.registerFCM(fcm, topics: [], authenticationToken: "")

        XCTAssertEqual(fcm, capturingJSONSession.postedJSONValue(forKey: "DeviceId"))
    }

    func testRegisteringTheFCMTokenShouldSupplyTheLiveTopicWithinAnArrayUnderTheTopicsKey() {
        let capturingJSONSession = CapturingJSONSession()
        let registration = EurofurenceFCMDeviceRegistration(JSONSession: capturingJSONSession)
        let topic = FirebaseTopic.live
        registration.registerFCM("", topics: [topic], authenticationToken: "")
        let expected: [String] = [topic.description]

        XCTAssertEqual(expected, capturingJSONSession.postedJSONValue(forKey: "Topics") ?? [])
    }

    func testRegisteringTheFCMTokenShouldSupplyTheTestTopicWithinAnArrayUnderTheTopicsKey() {
        let capturingJSONSession = CapturingJSONSession()
        let registration = EurofurenceFCMDeviceRegistration(JSONSession: capturingJSONSession)
        let topic = FirebaseTopic.test
        registration.registerFCM("", topics: [topic], authenticationToken: "")
        let expected: [String] = [topic.description]

        XCTAssertEqual(expected, capturingJSONSession.postedJSONValue(forKey: "Topics") ?? [])
    }

    func testRegisteringTheFCMTokenShouldSupplyAllTopicsWithinAnArrayUnderTheTopicsKey() {
        let capturingJSONSession = CapturingJSONSession()
        let registration = EurofurenceFCMDeviceRegistration(JSONSession: capturingJSONSession)
        let topics: [FirebaseTopic] = [.test, .live]
        registration.registerFCM("", topics: topics, authenticationToken: "")
        let expected: [String] = topics.map({ $0.description })

        XCTAssertEqual(expected, capturingJSONSession.postedJSONValue(forKey: "Topics") ?? [])
    }
    
    func testRegisteringTheFCMTokenWithUserAuthenticationTokenSuppliesItUsingTheAuthHeader() {
        let authenticationToken = "Token"
        let capturingJSONSession = CapturingJSONSession()
        let registration = EurofurenceFCMDeviceRegistration(JSONSession: capturingJSONSession)
        registration.registerFCM("", topics: [], authenticationToken: authenticationToken)
        
        XCTAssertEqual("Bearer \(authenticationToken)", capturingJSONSession.capturedAdditionalPOSTHeaders?["Authorization"])
    }
    
    func testRegisteringTheFCMTokenWithoutUserAuthenticationTokenDoesNotSupplyAuthHeader() {
        let capturingJSONSession = CapturingJSONSession()
        let registration = EurofurenceFCMDeviceRegistration(JSONSession: capturingJSONSession)
        registration.registerFCM("", topics: [], authenticationToken: nil)
        
        XCTAssertNil(capturingJSONSession.capturedAdditionalPOSTHeaders?["Authorization"])
    }
    
}
