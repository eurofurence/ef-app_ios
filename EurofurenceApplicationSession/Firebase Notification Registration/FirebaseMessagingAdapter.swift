import FirebaseMessaging
import Foundation

struct FirebaseMessagingAdapter: FirebaseAdapter {

    private let messaging = Messaging.messaging()

    var fcmToken: String {
        return messaging.fcmToken ?? ""
    }

    func setAPNSToken(deviceToken: Data?) {
        messaging.apnsToken = deviceToken
    }

    func subscribe(toTopic topic: FirebaseTopic) {
        messaging.subscribe(toTopic: topic.description)
    }

    func unsubscribe(fromTopic topic: FirebaseTopic) {
        messaging.unsubscribe(fromTopic: topic.description)
    }

}
