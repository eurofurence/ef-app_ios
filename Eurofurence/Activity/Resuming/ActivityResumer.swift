import EurofurenceModel
import Foundation

struct ActivityResumer {
    
    private let contentRouter: ContentRouter
    private let contentLinksService: ContentLinksService
    
    init(contentLinksService: ContentLinksService, contentRouter: ContentRouter) {
        self.contentLinksService = contentLinksService
        self.contentRouter = contentRouter
    }
    
    func resume(activity: ActivityDescription) -> Bool {
        let handler = ActivityHandler(contentRouter: contentRouter, contentLinksService: contentLinksService)
        return handler.handle(activity: activity)
    }
    
    private class ActivityHandler: ActivityDescriptionVisitor {
        
        private let contentRouter: ContentRouter
        private let contentLinksService: ContentLinksService
        private(set) var handledActivity = false
        
        init(contentRouter: ContentRouter, contentLinksService: ContentLinksService) {
            self.contentRouter = contentRouter
            self.contentLinksService = contentLinksService
        }
        
        func handle(activity: ActivityDescription) -> Bool {
            activity.describe(to: self)
            return handledActivity
        }
        
        func visitIntent(_ intent: Any) {
            let intentHandler = IntentActivityHandler(contentRouter: contentRouter)
            handledActivity = intentHandler.handle(intent: intent)
        }
        
        func visitURL(_ url: URL) {
            let urlHandler = URLActivityHandler(contentRouter: contentRouter, contentLinksService: contentLinksService)
            handledActivity = urlHandler.handle(url: url)
        }
        
    }
    
    private class IntentActivityHandler {
        
        private let contentRouter: ContentRouter
        
        init(contentRouter: ContentRouter) {
            self.contentRouter = contentRouter
        }
        
        func handle(intent: Any) -> Bool {
            var handledActivity = false
            
            if let intent = intent as? EventIntentDefinitionProviding, let intentDefinition = intent.eventIntentDefinition {
                contentRouter.resumeViewingEvent(identifier: intentDefinition.identifier)
                handledActivity = true
            }
            
            if let intent = intent as? DealerIntentDefinitionProviding, let intentDefinition = intent.dealerIntentDefinition {
                contentRouter.resumeViewingDealer(identifier: intentDefinition.identifier)
                handledActivity = true
            }
            
            return handledActivity
        }
        
    }
    
    private class URLActivityHandler: URLContentVisitor {
        
        private let contentRouter: ContentRouter
        private let contentLinksService: ContentLinksService
        private var handledContent = false
        
        init(contentRouter: ContentRouter, contentLinksService: ContentLinksService) {
            self.contentRouter = contentRouter
            self.contentLinksService = contentLinksService
        }
        
        func handle(url: URL) -> Bool {
            contentLinksService.describeContent(in: url, toVisitor: self)
            return handledContent
        }
        
        func visit(_ event: EventIdentifier) {
            contentRouter.resumeViewingEvent(identifier: event)
            handledContent = true
        }
        
        func visit(_ dealer: DealerIdentifier) {
            contentRouter.resumeViewingDealer(identifier: dealer)
            handledContent = true
        }
        
    }
    
}
