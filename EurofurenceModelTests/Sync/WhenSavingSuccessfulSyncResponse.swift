import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSavingSuccessfulSyncResponse: XCTestCase {
    
    private class TransactionSpyDataStore: InMemoryDataStore {
        
        var transactionInvokedBlock: (() -> Void)?
        override func performTransaction(_ block: @escaping (DataStoreTransaction) -> Void) {
            super.performTransaction(block)
            transactionInvokedBlock?()
        }
        
    }

    func testTheCompletionHandlerIsNotInvokedUntilDataStoreTransactionCompletes() {
        let dataStore = TransactionSpyDataStore()
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        var invokedWithNilError = false
        context.refreshLocalStore { invokedWithNilError = $0 == nil }
        
        dataStore.transactionInvokedBlock = {
            XCTAssertFalse(invokedWithNilError)
        }
        
        context.api.simulateSuccessfulSync(.randomWithoutDeletions)
    }

}
