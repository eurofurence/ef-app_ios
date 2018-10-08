//
//  WhenToldToHandleNotification_ThatConcludesWithEvent_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenToldToHandleNotification_ThatConcludesWithEvent_DirectorShould: XCTestCase {
    
    func testReturnNoDataToRefreshHandler() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let payload = [String.random : String.random]
        let event = Event2.Identifier.random
        context.notificationHandling.stub(.event(event), for: payload)
        var result: UIBackgroundFetchResult?
        context.director.handleRemoteNotification(payload) { result = $0 }
        
        XCTAssertEqual(UIBackgroundFetchResult.noData, result)
    }
    
}
