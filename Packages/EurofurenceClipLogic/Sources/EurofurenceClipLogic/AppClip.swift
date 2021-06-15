import EurofurenceApplicationSession
import EurofurenceModel
import UIKit

public class AppClip {
    
    public static let shared = AppClip()
    
    private let session: EurofurenceSession
    private var appClipWindowAssembler: AppClipWindowAssembler?
    
    private init() {
        session = EurofurenceSessionBuilder
            .buildingForEurofurenceApplication()
            .with(FinishStraightAwayRefreshCollaboration())
            .build()
    }
    
    public func configurePrincipalAppClipScene(window: UIWindow) {
        appClipWindowAssembler = AppClipWindowAssembler(
            window: window,
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
