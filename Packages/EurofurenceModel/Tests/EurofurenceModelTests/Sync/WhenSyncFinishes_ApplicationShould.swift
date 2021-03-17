import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenSyncFinishes_ApplicationShould: XCTestCase {

    class SingleTransactionOnlyAllowedDataStore: InMemoryDataStore {

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
