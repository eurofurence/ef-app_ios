import CoreData
@testable import EurofurenceKit
import XCTest

class ReadingRemoteConfigurationTests: XCTestCase {
    
    func testReadsConventionStartDate() async throws {
        let remoteConfiguration = FakeRemoteConfiguration()
        let now = Date()
        remoteConfiguration[RemoteConfigurationKeys.ConventionStartTime.self] = now
        let scenario = await EurofurenceModelTestBuilder().with(remoteConfiguration: remoteConfiguration).build()
        
        XCTAssertEqual(now, scenario.model.conventionStartTime)
    }

}
