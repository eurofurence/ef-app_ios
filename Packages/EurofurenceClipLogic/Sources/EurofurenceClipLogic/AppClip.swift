import DealerComponent
import EurofurenceApplicationSession
import EurofurenceModel
import EventDetailComponent
import UIKit

public class AppClip {
    
    public struct Dependencies {
        
        public let eventIntentDonor: EventIntentDonor
        public let dealerIntentDonor: ViewDealerIntentDonor
        
        public init(eventIntentDonor: EventIntentDonor, dealerIntentDonor: ViewDealerIntentDonor) {
            self.eventIntentDonor = eventIntentDonor
            self.dealerIntentDonor = dealerIntentDonor
        }
        
    }
    
    public private(set) static var shared: AppClip!
    
    private let dependencies: Dependencies
    private let session: EurofurenceSession
    
    public static func bootstrap(_ dependencies: Dependencies) {
        shared = AppClip(dependencies: dependencies)
    }
    
    private init(dependencies: Dependencies) {
        self.dependencies = dependencies
        
        session = EurofurenceSessionBuilder
            .buildingForEurofurenceApplication()
            .with(FinishStraightAwayRefreshCollaboration())
            .build()
    }
    
    public func configurePrincipalAppClipScene(window: UIWindow) -> WindowScene {
        PrincipalWindowScene(
            window: window,
            dependencies: dependencies,
            repositories: session.repositories,
            services: session.services
        )
    }
    
    private struct FinishStraightAwayRefreshCollaboration: RefreshCollaboration {
        
        func executeCollaborativeRefreshTask(completionHandler: @escaping (Error?) -> Void) {
            completionHandler(nil)
        }
        
    }
    
}

public protocol WindowScene {
    
    func resume(_ activity: NSUserActivity)
    func open(URLContexts: Set<UIOpenURLContext>)
    
}
