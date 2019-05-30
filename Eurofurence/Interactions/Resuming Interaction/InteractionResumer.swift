import Foundation

struct InteractionResumer {
    
    private let resumeResponseHandler: ResumeInteractionResponseHandler
    
    init(resumeResponseHandler: ResumeInteractionResponseHandler) {
        self.resumeResponseHandler = resumeResponseHandler
    }
    
    func resume(intent: Any?) -> Bool {
        if let intent = intent as? EventIntentDefinitionProviding, let intentDefinition = intent.eventIntentDefinition {
            resumeResponseHandler.resumeViewingEvent(identifier: intentDefinition.identifier)
            return true
        }
        
        if intent is OpenCollectThemAllIntentDefinitionProviding {
            resumeResponseHandler.resumeCollectThemAll()
            return true
        }
        
        return false
    }
    
}
