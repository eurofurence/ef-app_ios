import ComponentBase
import DealerComponent
import EventDetailComponent
import EventsJourney
import UIKit

extension AppClip {
    
    struct RouterConfigurator {
        
        private let window: UIWindow
        private let clipContentScene: ClipContentScene
        private let components: Components
        
        init(window: UIWindow, clipContentScene: ClipContentScene, components: Components) {
            self.window = window
            self.clipContentScene = clipContentScene
            self.components = components
        }
        
        func configure(_ router: MutableContentRouter) {
            let leaveFeedback = LeaveFeedbackFromEventNavigator(router: router)
            
            let contentWireframe = WindowContentWireframe(window: window)
            
            let scheduleRoute = ReplaceSceneWithScheduleRoute(scene: clipContentScene)
            router.add(scheduleRoute)
            
            let eventRoute = EventContentRoute(
                eventModuleFactory: components.eventDetailComponentFactory,
                eventDetailDelegate: leaveFeedback,
                contentWireframe: contentWireframe
            )
            
            router.add(eventRoute)
            
            let dealersRoute = ReplaceSceneWithDealersRoute(scene: clipContentScene)
            router.add(dealersRoute)
            
            let dealerRoute = DealerContentRoute(
                dealerModuleFactory: components.dealerDetailModuleProviding,
                contentWireframe: contentWireframe
            )
            
            router.add(dealerRoute)
        }
        
    }
    
}
