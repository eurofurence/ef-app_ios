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
        context.application.handleRemoteNotification(payload: payload) { (_) in }
        
        XCTAssertTrue(context.syncAPI.didBeginSync)
    }
    
    func testProvideSyncSuccessResultWhenDownloadSucceeds() {
        let context = ApplicationTestBuilder().build()
        let payload: [String : String] = ["event" : "sync"]
        context.application.handleRemoteNotification(payload: payload) { (_) in }
        var result: ApplicationPushActionResult?
        context.application.handleRemoteNotification(payload: payload) { result = $0 }
        context.syncAPI.simulateSuccessfulSync(.randomWithoutDeletions)
        
        XCTAssertEqual(.successfulSync, result)
    }
    
    func testProideSyncFailedResponseWhenDownloadFails() {
        let context = ApplicationTestBuilder().build()
        let payload: [String : String] = ["event" : "sync"]
        var result: ApplicationPushActionResult?
        context.application.handleRemoteNotification(payload: payload) { result = $0 }
        context.syncAPI.simulateUnsuccessfulSync()
        
        XCTAssertEqual(.failedSync, result)
    }
    
}
