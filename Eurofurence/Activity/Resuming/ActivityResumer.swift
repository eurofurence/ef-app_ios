import Foundation

struct ActivityResumer {
    
    private let resumeResponseHandler: ContentRouter
    
    init(resumeResponseHandler: ContentRouter) {
        self.resumeResponseHandler = resumeResponseHandler
    }
    
    func resume(activity: ActivityDescription) -> Bool {
        let handler = ActivityHandler(resumeResponseHandler: resumeResponseHandler)
        activity.describe(to: handler)
        
        return handler.handledActivity
    }
    
    private class ActivityHandler: ActivityDescriptionVisitor {
        
        private let resumeResponseHandler: ContentRouter
        private(set) var handledActivity = false
        
        init(resumeResponseHandler: ContentRouter) {
            self.resumeResponseHandler = resumeResponseHandler
        }
        
        func visitIntent(_ intent: Any) {
            if let intent = intent as? EventIntentDefinitionProviding, let intentDefinition = intent.eventIntentDefinition {
                resumeResponseHandler.resumeViewingEvent(identifier: intentDefinition.identifier)
                handledActivity = true
            }
        }
        
    }
    
}
