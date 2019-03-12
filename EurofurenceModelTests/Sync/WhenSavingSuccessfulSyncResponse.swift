//
//  WhenSavingSuccessfulSyncResponse.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenSavingSuccessfulSyncResponse: XCTestCase {

    func testTheCompletionHandlerIsNotInvokedUntilDataStoreTransactionCompletes() {
        let context = EurofurenceSessionTestBuilder().build()
        var invokedWithNilError = false
        context.refreshLocalStore { invokedWithNilError = $0 == nil }
        context.dataStore.transactionInvokedBlock = {
            XCTAssertFalse(invokedWithNilError)
        }

        context.api.simulateSuccessfulSync(.randomWithoutDeletions)
    }

}
