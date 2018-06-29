//
//  WhenApplicationRefreshStateChanges_NewsInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 30/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import XCTest

class WhenApplicationRefreshStateChanges_NewsInteractorShould: XCTestCase {
    
    func testTellTheDelegateWhenTheAppBeginsRefreshing() {
        let context = DefaultNewsInteractorTestBuilder().build()
        context.subscribeViewModelUpdates()
        context.refreshService.simulateRefreshBegan()
        
        XCTAssertTrue(context.delegate.toldRefreshDidBegin)
    }
    
    func testTellTheDelegateWhenTheAppFinishesRefreshing() {
        let context = DefaultNewsInteractorTestBuilder().build()
        context.subscribeViewModelUpdates()
        context.refreshService.simulateRefreshFinished()
        
        XCTAssertTrue(context.delegate.toldRefreshDidFinish)
    }
    
}
