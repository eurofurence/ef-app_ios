//
//  WhenToldToOpenNotification_ThatRepresentsEventReminder_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenToldToOpenNotification_ThatRepresentsEventReminder_ApplicationShould: XCTestCase {
    
    func testNotRefreshTheLocalStore() {
        let context = ApplicationTestBuilder().build()
        let payload: [String : String] = [
            ApplicationNotificationKey.notificationContentKind.rawValue : ApplicationNotificationContentKind.event.rawValue,
            ApplicationNotificationKey.notificationContentIdentifier.rawValue : String.random
        ]
        
        context.application.handleRemoteNotification(payload: payload) { (_) in }
        
        XCTAssertFalse(context.syncAPI.didBeginSync)
    }
    
    func testProvideEventIdentifierInCompletionHandler() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let event = syncResponse.events.changed.randomElement().element
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let payload: [String : String] = [
            ApplicationNotificationKey.notificationContentKind.rawValue : ApplicationNotificationContentKind.event.rawValue,
            ApplicationNotificationKey.notificationContentIdentifier.rawValue : event.identifier
        ]
        
        var result: ApplicationPushActionResult?
        context.application.handleRemoteNotification(payload: payload) { result = $0 }
        
        XCTAssertEqual(ApplicationPushActionResult.event(Event2.Identifier(event.identifier)), result)
    }
    
    func testProvideUnknownActionWhenMissingContentIdentifierKey() {
        let context = ApplicationTestBuilder().build()
        let payload: [String : String] = [
            ApplicationNotificationKey.notificationContentKind.rawValue : ApplicationNotificationContentKind.event.rawValue
        ]
        
        var result: ApplicationPushActionResult?
        context.application.handleRemoteNotification(payload: payload) { result = $0 }
        
        XCTAssertEqual(ApplicationPushActionResult.unknown, result)
    }
    
    func testProvideUnknownActionWhenEventWithIdentifierDoesNotExistWithinStore() {
        let context = ApplicationTestBuilder().build()
        let payload: [String : String] = [
            ApplicationNotificationKey.notificationContentKind.rawValue : ApplicationNotificationContentKind.event.rawValue,
            ApplicationNotificationKey.notificationContentIdentifier.rawValue : String.random
        ]
        
        var result: ApplicationPushActionResult?
        context.application.handleRemoteNotification(payload: payload) { result = $0 }
        
        XCTAssertEqual(ApplicationPushActionResult.unknown, result)
    }
    
}
