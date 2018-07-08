//
//  WhenToldToHandleNotification_ThatConcludesWithSuccessfulSync_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenToldToHandleNotification_ThatConcludesWithSuccessfulSync_DirectorShould: XCTestCase {
    
    func testInvokeTheHandlerWithNewDataResult() {
        let context = ApplicationDirectorTestBuilder().build()
        let payload = [String.random : String.random]
        context.notificationHandling.stub(.successfulSync, for: payload)
        var result: UIBackgroundFetchResult?
        context.director.handleRemoteNotification(payload) { result = $0 }
        
        XCTAssertEqual(UIBackgroundFetchResult.newData, result)
    }
    
}
