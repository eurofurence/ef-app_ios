import TutorialComponent

class WellBehavedAcknowledgedPushPermissions: WitnessedTutorialPushPermissionsRequest {

    var witnessedTutorialPushPermissionsRequest: Bool = false

    func markWitnessedTutorialPushPermissionsRequest() {
        witnessedTutorialPushPermissionsRequest = true
    }

}

struct UserNotAcknowledgedPushPermissions: WitnessedTutorialPushPermissionsRequest {

    var witnessedTutorialPushPermissionsRequest: Bool {
        return false
    }

    func markWitnessedTutorialPushPermissionsRequest() { }

}

struct UserAcknowledgedPushPermissions: WitnessedTutorialPushPermissionsRequest {

    var witnessedTutorialPushPermissionsRequest: Bool {
        return true
    }

    func markWitnessedTutorialPushPermissionsRequest() { }

}

class CapturingUserAcknowledgedPushPermissions: WitnessedTutorialPushPermissionsRequest {

    var witnessedTutorialPushPermissionsRequest: Bool {
        return false
    }

    private(set) var didMarkUserAsAcknowledgingPushPermissionsRequest = false
    func markWitnessedTutorialPushPermissionsRequest() {
        didMarkUserAsAcknowledgingPushPermissionsRequest = true
    }

}
