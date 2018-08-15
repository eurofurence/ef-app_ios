//
//  UserDefaultsReviewPromptAppVersionRepository.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct UserDefaultsReviewPromptAppVersionRepository: ReviewPromptAppVersionRepository {

    private struct Keys {
        static let lastPromptedAppVersionKey = "EFLastAppVersionUserWitnessedReviewPrompt"
    }

    var userDefaults: UserDefaults = .standard

    var lastPromptedAppVersion: String? {
        return userDefaults.string(forKey: Keys.lastPromptedAppVersionKey)
    }

    func setLastPromptedAppVersion(_ lastPromptedAppVersion: String) {
        userDefaults.set(lastPromptedAppVersion, forKey: Keys.lastPromptedAppVersionKey)
    }

}
