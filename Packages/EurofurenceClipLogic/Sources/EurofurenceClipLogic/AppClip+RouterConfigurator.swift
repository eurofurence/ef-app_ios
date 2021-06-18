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
            let contentWireframe = WindowContentWireframe(window: window)
            
            addScheduleRoute(router)
            addDealersRoute(router)
            addEventRoute(router, contentWireframe)
            addDealerRoute(contentWireframe, router)
        }
        
        private func addScheduleRoute(_ router: MutableContentRouter) {
            let scheduleRoute = ReplaceSceneWithScheduleRoute(scene: clipContentScene)
            router.add(scheduleRoute)
        }
        
        private func addDealersRoute(_ router: MutableContentRouter) {
            let dealersRoute = ReplaceSceneWithDealersRoute(scene: clipContentScene)
            router.add(dealersRoute)
        }
        
        private func addEventRoute(_ router: MutableContentRouter, _ contentWireframe: WindowContentWireframe) {
            let leaveFeedback = LeaveFeedbackFromEventNavigator(router: router)
            
            let eventRoute = EventContentRoute(
                eventModuleFactory: components.eventDetailComponentFactory,
                eventDetailDelegate: leaveFeedback,
                contentWireframe: contentWireframe
            )
            
            router.add(eventRoute)
        }
        
        private func addDealerRoute(_ contentWireframe: WindowContentWireframe, _ router: MutableContentRouter) {
            let dealerRoute = DealerContentRoute(
                dealerModuleFactory: components.dealerDetailModuleProviding,
                contentWireframe: contentWireframe
            )
            
            router.add(dealerRoute)
        }
        
    }
    
}
