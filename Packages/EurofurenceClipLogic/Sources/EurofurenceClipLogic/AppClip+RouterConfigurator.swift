import ComponentBase
import DealerComponent
import EventDetailComponent
import EventsJourney
import UIKit

extension AppClip {
    
    struct RouterConfigurator {
        
        private let window: UIWindow
        private let components: Components
        
        init(window: UIWindow, components: Components) {
            self.window = window
            self.components = components
        }
        
        func configure(_ router: MutableContentRouter) {
            let leaveFeedback = LeaveFeedbackFromEventNavigator(router: router)
            
            let contentWireframe = WindowContentWireframe(window: window)
            
            let eventRoute = EventContentRoute(
                eventModuleFactory: components.eventDetailComponentFactory,
                eventDetailDelegate: leaveFeedback,
                contentWireframe: contentWireframe
            )
            
            router.add(eventRoute)
            
            let dealerRoute = DealerContentRoute(
                dealerModuleFactory: components.dealerDetailModuleProviding,
                contentWireframe: contentWireframe
            )
            
            router.add(dealerRoute)
        }
        
    }
    
}
