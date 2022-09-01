@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class AppGroupModelPropertiesTests: XCTestCase {
    
    private var userDefaults: UserDefaults!
    
    override func setUp() async throws {
        try await super.setUp()
        userDefaults = try XCTUnwrap(UserDefaults(suiteName: "Test"))
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        userDefaults.set(nil, forKey: "EFKSynchronizationGenerationTokenData")
    }
    
    func testArchivesSyncToken() {
        var properties = AppGroupModelProperties(userDefaults: userDefaults)
        
        XCTAssertNil(properties.synchronizationChangeToken, "No change token should be present for a new instance")
        
        let token = SynchronizationPayload.GenerationToken(lastSyncTime: Date())
        properties.synchronizationChangeToken = token
        
        properties = AppGroupModelProperties(userDefaults: userDefaults)
        
        XCTAssertEqual(
            token,
            properties.synchronizationChangeToken,
            "Should read back the same token from the same UserDefaults"
        )
    }
    
    func testSettingSyncTokenToNilWipesCurrentValue() {
        let properties = AppGroupModelProperties(userDefaults: userDefaults)
        let token = SynchronizationPayload.GenerationToken(lastSyncTime: Date())
        properties.synchronizationChangeToken = token
        properties.synchronizationChangeToken = nil
        
        XCTAssertNil(properties.synchronizationChangeToken, "Token should be forgotten when set to nil")
    }

}
