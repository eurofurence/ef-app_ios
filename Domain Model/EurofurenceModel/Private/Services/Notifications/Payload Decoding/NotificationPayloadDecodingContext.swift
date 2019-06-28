import Foundation

class NotificationPayloadDecodingContext {
    
    private let payload: [String: String]
    private let completionHandler: (NotificationContent) -> Void
    
    init(payload: [String: String], completionHandler: @escaping (NotificationContent) -> Void) {
        self.payload = payload
        self.completionHandler = completionHandler
    }
    
    func complete(content: NotificationContent) {
        completionHandler(content)
    }
    
    func value(forPayloadKey key: String) -> String? {
        return payload[key]
    }
    
}
