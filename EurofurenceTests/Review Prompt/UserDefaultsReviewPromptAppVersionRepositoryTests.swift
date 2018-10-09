//
//  UserDefaultsReviewPromptAppVersionRepositoryTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class UserDefaultsReviewPromptAppVersionRepositoryTests: XCTestCase {
    
    func testSavingVersionLoadsItLater() {
        let defaults = UserDefaults()
        var repository = UserDefaultsReviewPromptAppVersionRepository(userDefaults: defaults)
        let version = String.random
        repository.setLastPromptedAppVersion(version)
        repository = UserDefaultsReviewPromptAppVersionRepository(userDefaults: defaults)
        
        XCTAssertEqual(version, repository.lastPromptedAppVersion)
    }
    
}
