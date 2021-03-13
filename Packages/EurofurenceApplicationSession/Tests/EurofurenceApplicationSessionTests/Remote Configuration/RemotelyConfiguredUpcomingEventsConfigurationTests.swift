import EurofurenceApplicationSession
import EurofurenceModel
import XCTest

class RemotelyConfiguredUpcomingEventsConfigurationTests: XCTestCase {

    func testUsesStaticValueUntilPropertyIsRemotelyConfigurable() {
        let configuration = RemotelyConfiguredUpcomingEventsConfiguration()
        let expected: TimeInterval = 3600
        
        XCTAssertEqual(expected, configuration.intervalFromPresentForUpcomingEvents)
    }

}
