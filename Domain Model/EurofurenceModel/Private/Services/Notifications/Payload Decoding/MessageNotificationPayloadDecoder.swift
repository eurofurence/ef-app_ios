import Foundation

class MessageNotificationPayloadDecoder: NotificationPayloadDecoder {
    
    private let privateMessagesService: PrivateMessagesService
    
    init(nextComponent: NotificationPayloadDecoder?, privateMessagesService: PrivateMessagesService) {
        self.privateMessagesService = privateMessagesService
        super.init(nextComponent: nextComponent)
    }
    
    override func process(context: NotificationPayloadDecodingContext) {
        if let messageIdentifier = context.value(forPayloadKey: "message_id") {
            let identifier = MessageIdentifier(messageIdentifier)
            if privateMessagesService.fetchMessage(identifiedBy: identifier) != nil {
                context.complete(content: .message(identifier))
                return
            }
        }
        
        super.process(context: context)
    }
    
}
