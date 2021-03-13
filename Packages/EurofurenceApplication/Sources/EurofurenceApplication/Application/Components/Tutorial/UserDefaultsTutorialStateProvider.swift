import Foundation

public struct UserDefaultsTutorialStateProvider: UserCompletedTutorialStateProviding {

    public static let FinishedTutorialKey = "Eurofurence.UserHasFinishedTutorial"

    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public var userHasCompletedTutorial: Bool {
        return userDefaults.bool(forKey: UserDefaultsTutorialStateProvider.FinishedTutorialKey)
    }

    public func markTutorialAsComplete() {
        userDefaults.set(true, forKey: UserDefaultsTutorialStateProvider.FinishedTutorialKey)
    }

}
