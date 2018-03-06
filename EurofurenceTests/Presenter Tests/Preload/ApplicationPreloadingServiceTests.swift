//
//  ApplicationPreloadingServiceTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class ApplicationPreloadingServiceTests: XCTestCase {
    
    var app: CapturingEurofurenceApplication!
    var service: ApplicationPreloadingService!
    var delegate: CapturingPreloadServiceDelegate!
    
    override func setUp() {
        super.setUp()
        
        app = CapturingEurofurenceApplication()
        service = ApplicationPreloadingService(app: app)
        delegate = CapturingPreloadServiceDelegate()
    }
    
    private func beginPreload() {
        service.beginPreloading(delegate: delegate)
    }
    
    private func simulateRefreshFailure() {
        app.failLastRefresh()
    }
    
    private func simulateRefreshSuccess() {
        app.succeedLastRefresh()
    }
    
    func testPreloadingTellsAppToRefreshLocalStore() {
        beginPreload()
        XCTAssertTrue(app.wasToldToRefreshLocalStore)
    }
    
    func testFailedRefreshTellDelegatePreloadServiceFailed() {
        beginPreload()
        simulateRefreshFailure()
        
        XCTAssertTrue(delegate.wasToldPreloadServiceDidFail)
    }
    
    func testSuccessfulRefreshesDoNotTellDelegatePreloadServiceSucceeded() {
        beginPreload()
        simulateRefreshSuccess()
        
        XCTAssertFalse(delegate.wasToldPreloadServiceDidFail)
    }
    
    func testSuccessfulRefreshTellsDelegatePreloadServiceSucceeded() {
        beginPreload()
        simulateRefreshSuccess()
        
        XCTAssertTrue(delegate.wasToldPreloadServiceDidFinish)
    }
    
    func testFailedRefreshDoesNotTellDelegatePreloadServiceSucceeded() {
        beginPreload()
        simulateRefreshFailure()
        
        XCTAssertFalse(delegate.wasToldPreloadServiceDidFinish)
    }
    
}
