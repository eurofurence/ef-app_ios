@testable import EurofurenceWebAPI
import Foundation
import XCTest

class FirebaseRemoteConfigurationTests: XCTestCase {
    
    func testTellsConfigurationToAcquireRemoteValuesDuringPreparation() async throws {
        let narrowedConfiguration = FakeNarrowedFirebaseConfiguration()
        let firebaseConfiguration = FirebaseRemoteConfiguration(firebaseConfiguration: narrowedConfiguration)
        
        XCTAssertFalse(
            narrowedConfiguration.toldToAcquireRemoteValues,
            "Should not acquire remote values until told to"
        )
        
        await firebaseConfiguration.prepareConfiguration()
        
        XCTAssertTrue(
            narrowedConfiguration.toldToAcquireRemoteValues,
            "Should acquire remote values when told to"
        )
    }
    
    func testAdaptsConventionDateAsEpochTime() async throws {
        let conventionStartDateRelativeToEpoch: TimeInterval = 1551371501
        let expected = Date(timeIntervalSince1970: conventionStartDateRelativeToEpoch)
        let narrowedConfiguration = FakeNarrowedFirebaseConfiguration()
        narrowedConfiguration.stub(NSNumber(value: conventionStartDateRelativeToEpoch), forKey: "nextConStart")
        let firebaseConfiguration = FirebaseRemoteConfiguration(firebaseConfiguration: narrowedConfiguration)
        await firebaseConfiguration.prepareConfiguration()
        
        XCTAssertEqual(expected, firebaseConfiguration[RemoteConfigurationKeys.ConventionStartTime.self])
    }

}
