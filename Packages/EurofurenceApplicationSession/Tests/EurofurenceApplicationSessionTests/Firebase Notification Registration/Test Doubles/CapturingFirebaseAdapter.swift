import EurofurenceApplicationSession
import EurofurenceModel
import Foundation

class CapturingFirebaseAdapter: FirebaseAdapter {

    private(set) var registeredDeviceToken: Data?
    func setAPNSToken(deviceToken: Data?) {
        registeredDeviceToken = deviceToken
    }

    private var subscribedTopics = [FirebaseTopic]()
    func subscribe(toTopic topic: FirebaseTopic) {
        subscribedTopics.append(topic)
    }

    private var unsubscribedTopics = [FirebaseTopic]()
    func unsubscribe(fromTopic topic: FirebaseTopic) {
        unsubscribedTopics.append(topic)
    }

    var fcmToken: String = ""

    func didSubscribeToTopic(_ topic: FirebaseTopic) -> Bool {
        return subscribedTopics.contains(topic)
    }

    func didUnsubscribeFromTopic(_ topic: FirebaseTopic) -> Bool {
        return unsubscribedTopics.contains(topic)
    }

}
