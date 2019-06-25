import Foundation

public enum FirebaseTopic: CustomStringConvertible, Hashable {
    case ios
    case debug
    case version(String)
    case cid(String)
    case cidiOS(String)

    public static func == (lhs: FirebaseTopic, rhs: FirebaseTopic) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }

    public var description: String {
        switch self {
        case .ios:
            return "ios"
        case .debug:
            return "debug"
        case .version(let version):
            return "version-\(version)"
        case .cid(let cid):
            return "\(cid)"
        case .cidiOS(let cid):
            return "\(cid)-ios"
        }
    }

}

public protocol FirebaseAdapter {

    var fcmToken: String { get }

    func setAPNSToken(deviceToken: Data?)
    func subscribe(toTopic topic: FirebaseTopic)
    func unsubscribe(fromTopic topic: FirebaseTopic)

}
