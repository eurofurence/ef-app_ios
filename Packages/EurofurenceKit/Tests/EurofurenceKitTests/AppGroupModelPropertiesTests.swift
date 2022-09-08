@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class AppGroupModelPropertiesTests: EurofurenceKitTestCase {
    
    func testArchivesSyncToken() throws {
        let userDefaults = try XCTUnwrap(UserDefaults(suiteName: "Test"))
        
        addTeardownBlock {
            userDefaults.set(nil, forKey: "EFKSynchronizationGenerationTokenData")
        }
        
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
    
    func testSettingSyncTokenToNilWipesCurrentValue() throws {
        let userDefaults = try XCTUnwrap(UserDefaults(suiteName: "Test"))
        
        addTeardownBlock {
            userDefaults.set(nil, forKey: "EFKSynchronizationGenerationTokenData")
        }
        
        let properties = AppGroupModelProperties(userDefaults: userDefaults)
        let token = SynchronizationPayload.GenerationToken(lastSyncTime: Date())
        properties.synchronizationChangeToken = token
        properties.synchronizationChangeToken = nil
        
        XCTAssertNil(properties.synchronizationChangeToken, "Token should be forgotten when set to nil")
    }

}
