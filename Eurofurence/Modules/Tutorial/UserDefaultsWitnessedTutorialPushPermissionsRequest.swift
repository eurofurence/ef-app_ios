import Foundation

struct UserDefaultsWitnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest {

    static let WitnessedTutorialPushPermissionsRequestKey = "Eurofurence.WitnessedTutorialPushPermissionsRequest"

    var userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    var witnessedTutorialPushPermissionsRequest: Bool {
        return userDefaults.bool(forKey: UserDefaultsWitnessedTutorialPushPermissionsRequest.WitnessedTutorialPushPermissionsRequestKey)
    }

    func markWitnessedTutorialPushPermissionsRequest() {
        userDefaults.set(true, forKey: UserDefaultsWitnessedTutorialPushPermissionsRequest.WitnessedTutorialPushPermissionsRequestKey)
    }

}
