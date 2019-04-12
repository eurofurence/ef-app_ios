import Foundation

struct UserDefaultsTutorialStateProvider: UserCompletedTutorialStateProviding {

    static let FinishedTutorialKey = "Eurofurence.UserHasFinishedTutorial"

    var userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    var userHasCompletedTutorial: Bool {
        return userDefaults.bool(forKey: UserDefaultsTutorialStateProvider.FinishedTutorialKey)
    }

    func markTutorialAsComplete() {
        userDefaults.set(true, forKey: UserDefaultsTutorialStateProvider.FinishedTutorialKey)
    }

}
