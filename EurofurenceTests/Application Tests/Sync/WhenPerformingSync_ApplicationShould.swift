//
//  WhenPerformingSync_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 30/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Eurofurence
import XCTest

class CapturingRefreshServiceObserver: RefreshServiceObserver {
    
    private(set) var toldDidBeginRefreshing = false
    func refreshServiceDidBeginRefreshing() {
        toldDidBeginRefreshing = true
    }
    
    private(set) var toldDidFinishRefreshing = false
    func refreshServiceDidFinishRefreshing() {
        toldDidFinishRefreshing = true
    }
    
}

class WhenPerformingSync_ApplicationShould: XCTestCase {
    
    var context: ApplicationTestBuilder.Context!
    var refreshObserver: CapturingRefreshServiceObserver!
    
    override func setUp() {
        super.setUp()
        
        context = ApplicationTestBuilder().build()
        refreshObserver = CapturingRefreshServiceObserver()
        context.application.add(refreshObserver)
    }
    
    func testTellRefreshServiceObserversRefreshStarted() {
        context.refreshLocalStore()
        XCTAssertTrue(refreshObserver.toldDidBeginRefreshing)
    }
    
    func testTellRefreshServiceObserversWhenSyncFinishesSuccessfully() {
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(.randomWithoutDeletions)
        
        XCTAssertTrue(refreshObserver.toldDidFinishRefreshing)
    }
    
    func testTellRefreshServiceObserversWhenSyncFails() {
        context.refreshLocalStore()
        context.syncAPI.simulateUnsuccessfulSync()
        
        XCTAssertTrue(refreshObserver.toldDidFinishRefreshing)
    }
    
}
