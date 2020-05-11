import Eurofurence
import XCTest

class RemotelyConfiguredConventionStartDateRepositoryTests: XCTestCase {
    
    var configuredStartDate: Date!
    var consumer: CapturingConventionStartDateConsumer!
    var remoteConfigurationLoader: FakeRemoteConfigurationLoader!
    var repository: RemotelyConfiguredConventionStartDateRepository!
    
    override func setUp() {
        super.setUp()
        
        configuredStartDate = .random
        consumer = CapturingConventionStartDateConsumer()
        remoteConfigurationLoader = FakeRemoteConfigurationLoader()
        repository = RemotelyConfiguredConventionStartDateRepository(remoteConfigurationLoader: remoteConfigurationLoader)
    }
    
    private func simulateConfigurationLoaded() {
        let remoteConfiguration = RemoteConfiguration(conventionStartDate: configuredStartDate)
        remoteConfigurationLoader.simulateConfigurationLoaded(remoteConfiguration)
    }
    
    private func registerConsumer() {
        repository.addConsumer(consumer)
    }
    
    func testAddingConsumerThenReceievingConfigUpdate() {
        registerConsumer()
        simulateConfigurationLoaded()
        
        XCTAssertEqual(configuredStartDate, consumer.capturedStartDate)
    }
    
    func testReceievingConfigUpdateThenAddingConsumer() {
        simulateConfigurationLoaded()
        registerConsumer()
        
        XCTAssertEqual(configuredStartDate, consumer.capturedStartDate)
    }

}
