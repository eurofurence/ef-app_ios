import Foundation

public struct UserDefaultsWitnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest {

    public static let WitnessedTutorialPushPermissionsRequestKey = "Eurofurence.WitnessedTutorialPushPermissionsRequest"

    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public var witnessedTutorialPushPermissionsRequest: Bool {
        userDefaults.bool(
            forKey: UserDefaultsWitnessedTutorialPushPermissionsRequest.WitnessedTutorialPushPermissionsRequestKey
        )
    }

    public func markWitnessedTutorialPushPermissionsRequest() {
        userDefaults.set(
            true,
            forKey: UserDefaultsWitnessedTutorialPushPermissionsRequest.WitnessedTutorialPushPermissionsRequestKey
        )
    }

}
