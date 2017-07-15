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
        let capturingHTTPPoster = CapturingHTTPPoster()
        let registration = EurofurenceFCMDeviceRegistration(httpPoster: capturingHTTPPoster)
        registration.registerFCM("", topics: [])
        let expectedURL = "https://app.eurofurence.org/api/v2/PushNotifications/FcmDeviceRegistration"

        XCTAssertEqual(expectedURL, capturingHTTPPoster.postedURL)
    }

    func testRegisteringTheFCMTokenShouldNotSubmitPOSTRequestUntilRegistrationActuallyOccurs() {
        let capturingHTTPPoster = CapturingHTTPPoster()
        _ = EurofurenceFCMDeviceRegistration(httpPoster: capturingHTTPPoster)

        XCTAssertNil(capturingHTTPPoster.postedURL)
    }

    func testRegisteringTheFCMTokenShouldPostJSONBodyWithDeviceIDAsFCMToken() {
        let capturingHTTPPoster = CapturingHTTPPoster()
        let registration = EurofurenceFCMDeviceRegistration(httpPoster: capturingHTTPPoster)
        let fcm = "Something unique"
        registration.registerFCM(fcm, topics: [])

        XCTAssertEqual(fcm, capturingHTTPPoster.postedJSONValue(forKey: "DeviceId"))
    }

    func testRegisteringTheFCMTokenShouldSupplyTheLiveTopicWithinAnArrayUnderTheTopicsKey() {
        let capturingHTTPPoster = CapturingHTTPPoster()
        let registration = EurofurenceFCMDeviceRegistration(httpPoster: capturingHTTPPoster)
        let topic = FirebaseTopic.live
        registration.registerFCM("", topics: [topic])
        let expected: [String] = [topic.rawValue]

        XCTAssertEqual(expected, capturingHTTPPoster.postedJSONValue(forKey: "Topics") ?? [])
    }

    func testRegisteringTheFCMTokenShouldSupplyTheTestTopicWithinAnArrayUnderTheTopicsKey() {
        let capturingHTTPPoster = CapturingHTTPPoster()
        let registration = EurofurenceFCMDeviceRegistration(httpPoster: capturingHTTPPoster)
        let topic = FirebaseTopic.test
        registration.registerFCM("", topics: [topic])
        let expected: [String] = [topic.rawValue]

        XCTAssertEqual(expected, capturingHTTPPoster.postedJSONValue(forKey: "Topics") ?? [])
    }

    func testRegisteringTheFCMTokenShouldSupplyAllTopicsWithinAnArrayUnderTheTopicsKey() {
        let capturingHTTPPoster = CapturingHTTPPoster()
        let registration = EurofurenceFCMDeviceRegistration(httpPoster: capturingHTTPPoster)
        let topics: [FirebaseTopic] = [.test, .live]
        registration.registerFCM("", topics: topics)
        let expected: [String] = topics.map({ $0.rawValue })

        XCTAssertEqual(expected, capturingHTTPPoster.postedJSONValue(forKey: "Topics") ?? [])
    }
    
}
