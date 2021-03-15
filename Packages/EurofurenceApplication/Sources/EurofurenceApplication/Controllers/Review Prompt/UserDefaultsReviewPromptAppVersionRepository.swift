import Foundation

public struct UserDefaultsReviewPromptAppVersionRepository: ReviewPromptAppVersionRepository {

    private struct Keys {
        static let lastPromptedAppVersionKey = "EFLastAppVersionUserWitnessedReviewPrompt"
    }

    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public var lastPromptedAppVersion: String? {
        return userDefaults.string(forKey: Keys.lastPromptedAppVersionKey)
    }

    public func setLastPromptedAppVersion(_ lastPromptedAppVersion: String) {
        userDefaults.set(lastPromptedAppVersion, forKey: Keys.lastPromptedAppVersionKey)
    }

}
