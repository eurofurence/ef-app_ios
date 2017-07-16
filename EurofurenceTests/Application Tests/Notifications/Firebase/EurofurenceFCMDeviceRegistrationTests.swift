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
    
    func testRegisteringTheFCMTokenSubmitsPOSTRequestToFCMRegistrationURL() {
        let capturingJSONPoster = CapturingJSONPoster()
        let registration = EurofurenceFCMDeviceRegistration(jsonPoster: capturingJSONPoster)
        registration.registerFCM("", topics: [])
        let expectedURL = "https://app.eurofurence.org/api/v2/PushNotifications/FcmDeviceRegistration"

        XCTAssertEqual(expectedURL, capturingJSONPoster.postedURL)
    }

    func testRegisteringTheFCMTokenShouldNotSubmitPOSTRequestUntilRegistrationActuallyOccurs() {
        let capturingJSONPoster = CapturingJSONPoster()
        _ = EurofurenceFCMDeviceRegistration(jsonPoster: capturingJSONPoster)

        XCTAssertNil(capturingJSONPoster.postedURL)
    }

    func testRegisteringTheFCMTokenShouldPostJSONBodyWithDeviceIDAsFCMToken() {
        let capturingJSONPoster = CapturingJSONPoster()
        let registration = EurofurenceFCMDeviceRegistration(jsonPoster: capturingJSONPoster)
        let fcm = "Something unique"
        registration.registerFCM(fcm, topics: [])

        XCTAssertEqual(fcm, capturingJSONPoster.postedJSONValue(forKey: "DeviceId"))
    }

    func testRegisteringTheFCMTokenShouldSupplyTheLiveTopicWithinAnArrayUnderTheTopicsKey() {
        let capturingJSONPoster = CapturingJSONPoster()
        let registration = EurofurenceFCMDeviceRegistration(jsonPoster: capturingJSONPoster)
        let topic = FirebaseTopic.live
        registration.registerFCM("", topics: [topic])
        let expected: [String] = [topic.rawValue]

        XCTAssertEqual(expected, capturingJSONPoster.postedJSONValue(forKey: "Topics") ?? [])
    }

    func testRegisteringTheFCMTokenShouldSupplyTheTestTopicWithinAnArrayUnderTheTopicsKey() {
        let capturingJSONPoster = CapturingJSONPoster()
        let registration = EurofurenceFCMDeviceRegistration(jsonPoster: capturingJSONPoster)
        let topic = FirebaseTopic.test
        registration.registerFCM("", topics: [topic])
        let expected: [String] = [topic.rawValue]

        XCTAssertEqual(expected, capturingJSONPoster.postedJSONValue(forKey: "Topics") ?? [])
    }

    func testRegisteringTheFCMTokenShouldSupplyAllTopicsWithinAnArrayUnderTheTopicsKey() {
        let capturingJSONPoster = CapturingJSONPoster()
        let registration = EurofurenceFCMDeviceRegistration(jsonPoster: capturingJSONPoster)
        let topics: [FirebaseTopic] = [.test, .live]
        registration.registerFCM("", topics: topics)
        let expected: [String] = topics.map({ $0.rawValue })

        XCTAssertEqual(expected, capturingJSONPoster.postedJSONValue(forKey: "Topics") ?? [])
    }
    
}
