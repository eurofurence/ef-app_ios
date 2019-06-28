import Foundation

class NotificationPayloadDecoder {
    
    private let nextComponent: NotificationPayloadDecoder?
    
    init(nextComponent: NotificationPayloadDecoder?) {
        self.nextComponent = nextComponent
    }
    
    func process(context: NotificationPayloadDecodingContext) {
        nextComponent?.process(context: context)
    }
    
}
