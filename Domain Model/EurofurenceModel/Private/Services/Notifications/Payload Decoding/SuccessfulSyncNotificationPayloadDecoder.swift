import Foundation

class SuccessfulSyncNotificationPayloadDecoder: NotificationPayloadDecoder {
    
    override func process(context: NotificationPayloadDecodingContext) {
        context.complete(content: .successfulSync)
    }
    
}
