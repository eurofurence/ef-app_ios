//
//  UserDefaultsTutorialStateProvider.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import XCTest

struct UserDefaultsTutorialStateProvider: UserCompletedTutorialStateProviding {

    static let FinishedTutorialKey = "Eurofurence.UserHasFinishedTutorial"

    var userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    var userHasCompletedTutorial: Bool {
        return userDefaults.bool(forKey: UserDefaultsTutorialStateProvider.FinishedTutorialKey)
    }

}

class UserDefaultsTutorialStateProviderTests: XCTestCase {

    var defaults: UserDefaults!
    var launchStateProvider: UserDefaultsTutorialStateProvider!

    override func setUp() {
        super.setUp()

        defaults = UserDefaults()
        launchStateProvider = UserDefaultsTutorialStateProvider(userDefaults: defaults)

        removeValueForFinishedTutorialKeyFromDefaults()
    }

    private func removeValueForFinishedTutorialKeyFromDefaults() {
        defaults.removeObject(forKey: UserDefaultsTutorialStateProvider.FinishedTutorialKey)
    }
    
    func testUserDefaultsWithoutValueForFirstTimeStateDefaultShouldIndicateAppNotOpenedBefore() {
        XCTAssertFalse(launchStateProvider.userHasCompletedTutorial)
    }

    func testUserDefaultsWithTrueValueForFirstTimeStateKeyShouldIndicateAppOpenedBefore() {
        defaults.set(true, forKey: UserDefaultsTutorialStateProvider.FinishedTutorialKey)
        XCTAssertTrue(launchStateProvider.userHasCompletedTutorial)
    }

    func testUserDefaultsWithFalseValueForFirstTimeStateKeyShouldIndicateAppNotOpenedBefore() {
        defaults.set(false, forKey: UserDefaultsTutorialStateProvider.FinishedTutorialKey)
        XCTAssertFalse(launchStateProvider.userHasCompletedTutorial)
    }
    
}
