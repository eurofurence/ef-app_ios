@testable import Eurofurence
import XCTest

class RemotelyConfiguredConventionStartDateRepositoryTests: XCTestCase {
    
    var consumer: CapturingConventionStartDateConsumer!
    var remoteConfigurationLoader: FakeRemoteConfigurationLoader!
    var repository: RemotelyConfiguredConventionStartDateRepository!
    
    override func setUp() {
        super.setUp()
        
        consumer = CapturingConventionStartDateConsumer()
        remoteConfigurationLoader = FakeRemoteConfigurationLoader()
        repository = RemotelyConfiguredConventionStartDateRepository(remoteConfigurationLoader: remoteConfigurationLoader)
    }
    
    func testAddingConsumerThenReceievingConfigUpdate() {
        repository.addConsumer(consumer)
        let configuredStartDate = Date.random
        let remoteConfiguration = RemoteConfiguration(conventionStartDate: configuredStartDate)
        remoteConfigurationLoader.simulateLoadFinished(remoteConfiguration)
        
        XCTAssertEqual(configuredStartDate, consumer.capturedStartDate)
    }
    
    func testReceievingConfigUpdateThenAddingConsumer() {
        let configuredStartDate = Date.random
        let remoteConfiguration = RemoteConfiguration(conventionStartDate: configuredStartDate)
        remoteConfigurationLoader.simulateLoadFinished(remoteConfiguration)
        repository.addConsumer(consumer)
        
        XCTAssertEqual(configuredStartDate, consumer.capturedStartDate)
    }

}
