//
//  WhenSyncFinishes_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 05/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSyncFinishes_ApplicationShould: XCTestCase {

    class SingleTransactionOnlyAllowedDataStore: FakeDataStore {

        private var transactionCount = 0

        override func performTransaction(_ block: @escaping (DataStoreTransaction) -> Void) {
            super.performTransaction(block)
            transactionCount += 1
        }

        func verify(file: StaticString = #file, line: UInt = #line) {
            XCTAssertEqual(1, transactionCount, file: file, line: line)
        }

    }

    func testNotPerformMultipleTransactions() {
        let assertion = SingleTransactionOnlyAllowedDataStore()
        let context = EurofurenceSessionTestBuilder().with(assertion).build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)

        assertion.verify()
    }

}
