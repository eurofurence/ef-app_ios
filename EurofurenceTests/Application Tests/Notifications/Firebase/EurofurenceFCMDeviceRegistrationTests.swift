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

    func post(_ url: String)

}

class CapturingHTTPPoster: HTTPPoster {

    private(set) var postedURL: String?
    func post(_ url: String) {
        postedURL = url
    }

}

struct EurofurenceFCMDeviceRegistration: FCMDeviceRegistration {

    private var httpPoster: HTTPPoster

    init(httpPoster: HTTPPoster) {
        self.httpPoster = httpPoster
    }

    func registerFCM(_ fcm: String, topics: [FirebaseTopic]) {
        httpPoster.post("https://app.eurofurence.org/api/v2/PushNotifications/FcmDeviceRegistration")
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
    
}
