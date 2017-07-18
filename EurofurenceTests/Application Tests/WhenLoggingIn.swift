//
//  WhenLoggingIn.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenLoggingIn: XCTestCase {
    
    func testTheLoginEndpointShouldReceievePOSTRequest() {
        let jsonPoster = CapturingJSONPoster()
        let application = EurofurenceApplication(remoteNotificationsTokenRegistration: CapturingRemoteNotificationsTokenRegistration(),
                                                 loginController: CapturingLoginController(),
                                                 clock: StubClock(),
                                                 loginCredentialStore: CapturingLoginCredentialStore(),
                                                 jsonPoster: jsonPoster)
        application.login()
        
        XCTAssertEqual("https://app.eurofurence.org/api/v2/Tokens/RegSys", jsonPoster.postedURL)
    }
    
    func testTheLoginEndpointShouldNotReceievePOSTRequestUntilCallingLogin() {
        let jsonPoster = CapturingJSONPoster()
        _ = EurofurenceApplication(remoteNotificationsTokenRegistration: CapturingRemoteNotificationsTokenRegistration(),
                                                 loginController: CapturingLoginController(),
                                                 clock: StubClock(),
                                                 loginCredentialStore: CapturingLoginCredentialStore(),
                                                 jsonPoster: jsonPoster)
        
        XCTAssertNil(jsonPoster.postedURL)
    }
    
}
