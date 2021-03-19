import ComponentBase
import ContentController
import EurofurenceApplicationSession
import EurofurenceModel
import PreloadComponent
import TutorialComponent
import UIKit

struct DealersSceneAssembler {
    
    static func assemble(in scene: UIWindowScene, window: UIWindow) {
        let session = EurofurenceSessionBuilder
            .buildingForEurofurenceApplication()
            .with(FinishStraightAwayRefreshCollaboration())
            .build()
        
        let services = session.services
        
        let alertRouter = WindowAlertRouter(window: window)
        let tutorialComponent = TutorialModuleBuilder(alertRouter: alertRouter).build()
        
        let preloadInteractor = ApplicationPreloadInteractor(refreshService: services.refresh)
        let preloadComponent = PreloadComponentBuilder(
            preloadInteractor: preloadInteractor,
            alertRouter: alertRouter
        ).build()
        
        let appClipModule = DealerAppClipModule(services: services, window: window, windowScene: scene)
        
        let scene = ComponentBasedBootstrappingScene(
            windowWireframe: AppWindowWireframe(window: window),
            tutorialModule: tutorialComponent,
            preloadModule: preloadComponent,
            principalContentModule: appClipModule
        )
        
        _ = ContentSceneController(
            sessionState: services.sessionState,
            scene: scene
        )
    }
    
    private struct FinishStraightAwayRefreshCollaboration: RefreshCollaboration {
        
        func executeCollaborativeRefreshTask(completionHandler: @escaping (Error?) -> Void) {
            completionHandler(nil)
        }
        
    }
    
}
