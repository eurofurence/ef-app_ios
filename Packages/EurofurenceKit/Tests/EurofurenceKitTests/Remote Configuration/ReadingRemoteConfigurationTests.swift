import CoreData
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class ReadingRemoteConfigurationTests: XCTestCase {
    
    func testReadsConventionStartDate() async throws {
        let api = FakeEurofurenceAPI()
        let remoteConfiguration = await api.remoteConfiguration
        let now = Date()
        remoteConfiguration[RemoteConfigurationKeys.ConventionStartTime.self] = now
        let scenario = await EurofurenceModelTestBuilder().with(api: api).build()
        
        XCTAssertEqual(now, scenario.model.conventionStartTime)
    }
    
    func testUpdatesConventionStartTimeWhenAvailableLater() async throws {
        let api = FakeEurofurenceAPI()
        let remoteConfiguration = await api.remoteConfiguration
        let scenario = await EurofurenceModelTestBuilder().with(api: api).build()
        
        XCTAssertNil(scenario.model.conventionStartTime, "Convention start time not known at boot")
        
        var objectWillChange = false
        let cancellable = scenario.model.objectWillChange.sink { _ in
            objectWillChange = true
        }
        
        addTeardownBlock {
            cancellable.cancel()
        }
        
        let now = Date()
        remoteConfiguration[RemoteConfigurationKeys.ConventionStartTime.self] = now
        
        XCTAssertTrue(objectWillChange, "Should notify object changed when configuration made available later")
        XCTAssertEqual(now, scenario.model.conventionStartTime, "Convention start time made available after boot")
    }
    
    func testDoesNotNotifyObjectChangedWhenStartTimeHasNotActuallyChanged() async throws {
        let api = FakeEurofurenceAPI()
        let remoteConfiguration = await api.remoteConfiguration
        let now = Date()
        remoteConfiguration[RemoteConfigurationKeys.ConventionStartTime.self] = now
        let scenario = await EurofurenceModelTestBuilder().with(api: api).build()
        
        var objectWillChange = false
        let cancellable = scenario.model.objectWillChange.sink { _ in
            objectWillChange = true
        }
        
        addTeardownBlock {
            cancellable.cancel()
        }
        
        remoteConfiguration[RemoteConfigurationKeys.ConventionStartTime.self] = now
        
        XCTAssertFalse(objectWillChange, "Should not notify object changed when it hasn't actually changed")
    }

}
