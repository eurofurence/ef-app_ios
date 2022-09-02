import Combine
import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class ModelUpdateProgressTests: XCTestCase {

    func testInitialState() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        XCTAssertEqual(.idle, scenario.model.cloudStatus)
    }
    
    func testUpdatingStoreTransitionsThroughStates() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        
        let journal = CloudStatusJournal(model: scenario.model)
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        journal.assertWitnessedStatuses(.idle, .updating, .updated)
    }
    
    func testUpdateFailsTransitionsThroughStates() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        
        let journal = CloudStatusJournal(model: scenario.model)
        let payload = try SampleResponse.corruptEF26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        await XCTAssertEventuallyThrowsError { try await scenario.updateLocalStore() }
        
        journal.assertWitnessedStatuses(.idle, .updating, .failed)
    }
    
    private class CloudStatusJournal {
        
        private var statuses = [EurofurenceModel.CloudStatus]()
        private var subscription: AnyCancellable?
        
        init(model: EurofurenceModel) {
            subscription = model.$cloudStatus.sink { [weak self] status in
                self?.append(status)
            }
        }
        
        private func append(_ status: EurofurenceModel.CloudStatus) {
            statuses.append(status)
        }
        
        func assertWitnessedStatuses(_ expected: EurofurenceModel.CloudStatus ...) {
            XCTAssertEqual(statuses, expected)
        }
        
    }

}
