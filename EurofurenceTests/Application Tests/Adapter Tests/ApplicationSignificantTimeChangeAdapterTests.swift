//
//  ApplicationSignificantTimeChangeAdapterTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class ApplicationSignificantTimeChangeAdapterTests: XCTestCase {
    
    func testTellsTheDelegateWhenSignificantTimeChangeNotificationPublished() {
        let adapter = ApplicationSignificantTimeChangeAdapter()
        let delegate = CapturingSignificantTimeChangeAdapterDelegate()
        adapter.setDelegate(delegate)
        NotificationCenter.default.post(name: UIApplication.significantTimeChangeNotification, object: nil, userInfo: nil)
        
        XCTAssertTrue(delegate.toldSignificantTimeChangeOccurred)
    }
    
}
