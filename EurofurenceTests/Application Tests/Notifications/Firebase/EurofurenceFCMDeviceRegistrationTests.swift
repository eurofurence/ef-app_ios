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
        let capturingJSONPoster = CapturingJSONPoster()
        let registration = EurofurenceFCMDeviceRegistration(jsonPoster: capturingJSONPoster)
        registration.registerFCM("", topics: [], authenticationToken: "")
        let expectedURL = "https://app.eurofurence.org/api/v2/PushNotifications/FcmDeviceRegistration"

        XCTAssertEqual(expectedURL, capturingJSONPoster.postedURL)
    }

    func testRegisteringTheFCMTokenShouldNotSubmitRequestUntilRegistrationActuallyOccurs() {
        let capturingJSONPoster = CapturingJSONPoster()
        _ = EurofurenceFCMDeviceRegistration(jsonPoster: capturingJSONPoster)

        XCTAssertNil(capturingJSONPoster.postedURL)
    }

    func testRegisteringTheFCMTokenShouldPostJSONBodyWithDeviceIDAsFCMToken() {
        let capturingJSONPoster = CapturingJSONPoster()
        let registration = EurofurenceFCMDeviceRegistration(jsonPoster: capturingJSONPoster)
        let fcm = "Something unique"
        registration.registerFCM(fcm, topics: [], authenticationToken: "")

        XCTAssertEqual(fcm, capturingJSONPoster.postedJSONValue(forKey: "DeviceId"))
    }

    func testRegisteringTheFCMTokenShouldSupplyTheLiveTopicWithinAnArrayUnderTheTopicsKey() {
        let capturingJSONPoster = CapturingJSONPoster()
        let registration = EurofurenceFCMDeviceRegistration(jsonPoster: capturingJSONPoster)
        let topic = FirebaseTopic.live
        registration.registerFCM("", topics: [topic], authenticationToken: "")
        let expected: [String] = [topic.description]

        XCTAssertEqual(expected, capturingJSONPoster.postedJSONValue(forKey: "Topics") ?? [])
    }

    func testRegisteringTheFCMTokenShouldSupplyTheTestTopicWithinAnArrayUnderTheTopicsKey() {
        let capturingJSONPoster = CapturingJSONPoster()
        let registration = EurofurenceFCMDeviceRegistration(jsonPoster: capturingJSONPoster)
        let topic = FirebaseTopic.test
        registration.registerFCM("", topics: [topic], authenticationToken: "")
        let expected: [String] = [topic.description]

        XCTAssertEqual(expected, capturingJSONPoster.postedJSONValue(forKey: "Topics") ?? [])
    }

    func testRegisteringTheFCMTokenShouldSupplyAllTopicsWithinAnArrayUnderTheTopicsKey() {
        let capturingJSONPoster = CapturingJSONPoster()
        let registration = EurofurenceFCMDeviceRegistration(jsonPoster: capturingJSONPoster)
        let topics: [FirebaseTopic] = [.test, .live]
        registration.registerFCM("", topics: topics, authenticationToken: "")
        let expected: [String] = topics.map({ $0.description })

        XCTAssertEqual(expected, capturingJSONPoster.postedJSONValue(forKey: "Topics") ?? [])
    }
    
    func testRegisteringTheFCMTokenWithUserAuthenticationTokenSuppliesItUsingTheAuthHeader() {
        let authenticationToken = "Token"
        let capturingJSONPoster = CapturingJSONPoster()
        let registration = EurofurenceFCMDeviceRegistration(jsonPoster: capturingJSONPoster)
        registration.registerFCM("", topics: [], authenticationToken: authenticationToken)
        
        XCTAssertEqual("Bearer \(authenticationToken)", capturingJSONPoster.capturedAdditionalHeaders?["Authorization"])
    }
    
    func testRegisteringTheFCMTokenWithoutUserAuthenticationTokenDoesNotSupplyAuthHeader() {
        let capturingJSONPoster = CapturingJSONPoster()
        let registration = EurofurenceFCMDeviceRegistration(jsonPoster: capturingJSONPoster)
        registration.registerFCM("", topics: [], authenticationToken: nil)
        
        XCTAssertNil(capturingJSONPoster.capturedAdditionalHeaders?["Authorization"])
    }
    
}
