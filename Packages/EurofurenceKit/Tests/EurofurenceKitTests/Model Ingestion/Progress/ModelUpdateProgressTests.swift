import Combine
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTAsyncAssertions
import XCTest

class ModelUpdateProgressTests: EurofurenceKitTestCase {

    func testInitialState() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        XCTAssertEqual(.idle, scenario.model.cloudStatus)
    }
    
    func testUpdatingStoreTransitionsThroughStates() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        
        let journal = CloudStatusJournal(model: scenario.model)
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        journal.assertWitnessedStatuses(.idle, .updating(progress: .init()), .updated)
    }
    
    func testUpdateFailsTransitionsThroughStates() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        
        let journal = CloudStatusJournal(model: scenario.model)
        let payload = try SampleResponse.corruptEF26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        await XCTAssertEventuallyThrowsError { try await scenario.updateLocalStore() }
        
        journal.assertWitnessedStatuses(.idle, .updating(progress: .init()), .failed)
    }
    
    func testDuringUpdatePropogatesProgressEvents() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        
        let journal = CloudStatusJournal(model: scenario.model)
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        journal.assertUpdatingProgress()
    }
    
    @MainActor
    private class CloudStatusJournal {
        
        private var statuses = [EurofurenceModel.CloudStatus]()
        private var progressUpdates = [ProgressUpdate]()
        private var subscriptions = Set<AnyCancellable>()
        
        private struct ProgressUpdate {
            var fractionComplete: Double?
            var localizedDescription: String
        }
        
        init(model: EurofurenceModel) {
            model
                .$cloudStatus
                .sink { [weak self] status in
                    self?.append(status)
                }
                .store(in: &subscriptions)
        }
        
        private func append(_ status: EurofurenceModel.CloudStatus) {
            statuses.append(status)
            
            if case .updating(let progress) = status {
                progress
                    .$fractionComplete
                    .sink { [weak self] fractionComplete in
                        let update = ProgressUpdate(
                            fractionComplete: fractionComplete,
                            localizedDescription: progress.localizedDescription
                        )
                        
                        self?.progressUpdates.append(update)
                    }
                    .store(in: &subscriptions)
            }
        }
        
        func assertWitnessedStatuses(_ expected: EurofurenceModel.CloudStatus ...) {
            guard expected.count == statuses.count else {
                XCTFail("Different expected/actual status amounts")
                return
            }
            
            for (expected, actual) in zip(expected, statuses) {
                switch (expected, actual) {
                case (.updating, .updating):
                    // Statuses same - bypass progress
                    continue
                    
                default:
                    XCTAssertEqual(expected, actual)
                }
            }
        }
        
        func assertUpdatingProgress() {
            XCTAssertGreaterThan(progressUpdates.count, 4)
            
            var idx = 0
            var localizedDescriptions = Set<String>()
            while idx < progressUpdates.count {
                let update = progressUpdates[idx]
                localizedDescriptions.insert(update.localizedDescription)
                
                // We anticipate to see a few progress state transitions for f = fractionComplete:
                switch idx {
                case 0:
                    // - Initial state (undeterminate, f=nil)
                    XCTAssertNil(update.fractionComplete)
                    
                case progressUpdates.count - 1:
                    // - Images loaded (f=1.0)
                    XCTAssertEqual(1.0, update.fractionComplete)
                    
                default:
                    // - Image loaded (f=n/images.count)
                    if let fractionComplete = update.fractionComplete {
                        XCTAssertGreaterThan(fractionComplete, 0)
                        XCTAssertLessThan(fractionComplete, 1.0)
                    } else {
                        XCTFail("Expected a fraction of completeness")
                    }
                }
                
                idx += 1
            }
            
            // We should see the description update alongside fractionComplete. These may be the same due to the number
            // of updates we emit being quite granular, so check for an arbitrary amount proportional to the number
            // of updates.
            // Updating at least 10% of the fraction complete seems to be a good start.
            XCTAssertGreaterThan(localizedDescriptions.count, Int(Double(progressUpdates.count) * 0.1))
        }
        
    }

}
