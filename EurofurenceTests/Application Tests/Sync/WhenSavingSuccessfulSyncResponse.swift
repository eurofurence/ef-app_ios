//
//  WhenSavingSuccessfulSyncResponse.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenSavingSuccessfulSyncResponse: XCTestCase {
    
    func testTheCompletionHandlerIsNotInvokedUntilDataStoreTransactionCompletes() {
        let context = ApplicationTestBuilder().build()
        var invokedWithNilError = false
        context.refreshLocalStore { invokedWithNilError = $0 == nil }
        context.dataStore.transactionInvokedBlock = {
            XCTAssertFalse(invokedWithNilError)
        }
        
        context.syncAPI.simulateSuccessfulSync(.randomWithoutDeletions)
    }
    
}
