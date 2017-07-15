//
//  EurofurenceFCMDeviceRegistrationTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

protocol HTTPPoster {

    func post(_ url: String, body: Data)

}

class CapturingHTTPPoster: HTTPPoster {

    private(set) var postedURL: String?
    private var postedData: Data?
    func post(_ url: String, body: Data) {
        postedURL = url
        postedData = body
    }

    func postedJSONValue<T>(forKey key: String) -> T? {
        guard let postedData = postedData else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: postedData, options: .allowFragments) else { return nil }
        guard let jsonDictionary = json as? [String : Any] else { return nil }

        return jsonDictionary[key] as? T
    }

}

struct EurofurenceFCMDeviceRegistration: FCMDeviceRegistration {

    private var httpPoster: HTTPPoster

    init(httpPoster: HTTPPoster) {
        self.httpPoster = httpPoster
    }

    func registerFCM(_ fcm: String, topics: [FirebaseTopic]) {
        let formattedTopics = topics.map({ $0.rawValue })
        let jsonDictionary: [String : Any] = ["DeviceId" : fcm, "Topics" : formattedTopics]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDictionary, options: [])

        httpPoster.post("https://app.eurofurence.org/api/v2/PushNotifications/FcmDeviceRegistration",
                        body: jsonData)
    }

}

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
