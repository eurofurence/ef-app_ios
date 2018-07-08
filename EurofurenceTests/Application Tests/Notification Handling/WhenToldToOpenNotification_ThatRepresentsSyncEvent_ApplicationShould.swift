//
//  WhenToldToOpenNotification_ThatRepresentsSyncEvent_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenToldToOpenNotification_ThatRepresentsSyncEvent_ApplicationShould: XCTestCase {
    
    func testRefreshTheLocalStore() {
        let context = ApplicationTestBuilder().build()
        let payload: [String : String] = ["event" : "sync"]
        context.application.handleRemoteNotification(payload: payload)
        
        XCTAssertTrue(context.syncAPI.didBeginSync)
    }
    
}
