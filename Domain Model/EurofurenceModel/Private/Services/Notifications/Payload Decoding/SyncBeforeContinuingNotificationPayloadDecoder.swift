import Foundation

class SyncBeforeContinuingNotificationPayloadDecoder: NotificationPayloadDecoder {
    
    private let refreshService: RefreshService
    
    init(nextComponent: NotificationPayloadDecoder?, refreshService: RefreshService) {
        self.refreshService = refreshService
        super.init(nextComponent: nextComponent)
    }
    
    override func process(context: NotificationPayloadDecodingContext) {
        refreshService.refreshLocalStore { (error) in
            if error == nil {
                super.process(context: context)
            } else {
                context.complete(content: .failedSync)
            }
        }
    }
    
}
